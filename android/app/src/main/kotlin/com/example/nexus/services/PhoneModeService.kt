package com.example.nexus.services

import android.app.*
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.graphics.Color
import android.media.AudioManager
import android.os.Build
import android.os.IBinder
import android.os.PowerManager
import org.json.JSONArray
import org.json.JSONObject
import java.util.*
import java.util.concurrent.Executors
import java.util.concurrent.ScheduledExecutorService
import java.util.concurrent.TimeUnit
import android.app.NotificationManager
import android.media.RingtoneManager
import android.net.Uri
import android.app.PendingIntent
import android.content.ComponentName
import android.os.SystemClock
import android.app.AlarmManager

class PhoneModeService : Service() {
    private var scheduler: ScheduledExecutorService? = null
    private var rules: JSONArray = JSONArray()
    private lateinit var audioManager: AudioManager
    private lateinit var notificationManager: NotificationManager
    private lateinit var timeTickReceiver: BroadcastReceiver
    private var wakeLock: PowerManager.WakeLock? = null
    private lateinit var alarmManager: AlarmManager

    companion object {
        const val CHANNEL_ID = "NexusPhoneModeForeground"
        const val NOTIFICATION_ID = 1
        const val ACTION_START = "com.example.nexus.START_PHONE_MODE_SERVICE"
        const val ACTION_STOP = "com.example.nexus.STOP_PHONE_MODE_SERVICE"
        const val ACTION_UPDATE_RULES = "com.example.nexus.UPDATE_RULES"
        const val ACTION_RESTART_SERVICE = "com.example.nexus.RESTART_SERVICE"
        const val EXTRA_RULES = "rules_json"
        const val ALARM_REQUEST_CODE = 1001
        
        // Helper method to start the service from anywhere
        fun startService(context: Context) {
            val intent = Intent(context, PhoneModeService::class.java).apply {
                action = ACTION_START
            }
            
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(intent)
            } else {
                context.startService(intent)
            }
            
            // Also set up an alarm that will restart the service if it gets killed
            setupRestartAlarm(context)
        }
        
        // Set up a repeating alarm to ensure the service stays running
        fun setupRestartAlarm(context: Context) {
            val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            val intent = Intent(context, PhoneModeService::class.java).apply {
                action = ACTION_RESTART_SERVICE
            }
            
            val pendingIntent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                PendingIntent.getService(
                    context, ALARM_REQUEST_CODE, intent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )
            } else {
                PendingIntent.getService(
                    context, ALARM_REQUEST_CODE, intent,
                    PendingIntent.FLAG_UPDATE_CURRENT
                )
            }
            
            // Set alarm to trigger every 15 minutes
            alarmManager.setRepeating(
                AlarmManager.ELAPSED_REALTIME_WAKEUP,
                SystemClock.elapsedRealtime() + 15 * 60 * 1000, // 15 minutes from now
                15 * 60 * 1000, // every 15 minutes
                pendingIntent
            )
        }
    }

    override fun onCreate() {
        super.onCreate()
        audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
        notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
        
        // Create notification channel for foreground service
        createNotificationChannel()
        
        // Register for various broadcast receivers to keep the service alive and responsive
        registerReceivers()
        
        // Initialize scheduler for periodic checks
        scheduler = Executors.newSingleThreadScheduledExecutor()
        
        // Create a partial wake lock that will help keep the service running
        val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
        wakeLock = powerManager.newWakeLock(
            PowerManager.PARTIAL_WAKE_LOCK,
            "Nexus:PhoneModeWakeLock"
        ).apply {
            // Acquire wake lock indefinitely until explicitly released
            acquire()
        }
    }
    
    private fun registerReceivers() {
        // Register for time tick broadcast to update phone mode regularly
        timeTickReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                when (intent?.action) {
                    Intent.ACTION_TIME_TICK -> checkAndApplyRules()
                    Intent.ACTION_BOOT_COMPLETED -> context?.let { startService(it) }
                    Intent.ACTION_USER_PRESENT -> checkAndApplyRules()
                    Intent.ACTION_SCREEN_ON -> checkAndApplyRules()
                }
            }
        }
        
        val intentFilter = IntentFilter().apply {
            addAction(Intent.ACTION_TIME_TICK)
            addAction(Intent.ACTION_BOOT_COMPLETED)
            addAction(Intent.ACTION_USER_PRESENT)
            addAction(Intent.ACTION_SCREEN_ON)
        }
        registerReceiver(timeTickReceiver, intentFilter)
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when (intent?.action) {
            ACTION_START -> {
                startForeground(NOTIFICATION_ID, createNotification("Phone mode control active"))
                loadRulesFromSharedPreferences()
                startScheduler()
                
                // Set up restart alarm to make sure service stays running
                setupRestartAlarm(this)
            }
            ACTION_STOP -> {
                stopSelf()
            }
            ACTION_UPDATE_RULES -> {
                val rulesJson = intent.getStringExtra(EXTRA_RULES)
                if (rulesJson != null) {
                    updateRules(rulesJson)
                }
            }
            ACTION_RESTART_SERVICE -> {
                // This action is triggered by the alarm manager to restart the service if it was killed
                if (!isServiceRunningInForeground()) {
                    startForeground(NOTIFICATION_ID, createNotification("Phone mode control active"))
                    loadRulesFromSharedPreferences()
                    startScheduler()
                }
            }
        }
        
        // Using START_STICKY_COMPATIBILITY for maximum compatibility 
        // This flag tells the system to recreate the service if it is killed
        return START_STICKY
    }
    
    private fun isServiceRunningInForeground(): Boolean {
        val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as android.app.ActivityManager
        val services = activityManager.getRunningServices(Integer.MAX_VALUE)
        
        for (serviceInfo in services) {
            if (serviceInfo.service.className == this.javaClass.name) {
                return serviceInfo.foreground
            }
        }
        return false
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun onDestroy() {
        scheduler?.shutdown()
        try {
            unregisterReceiver(timeTickReceiver)
        } catch (e: Exception) {
            // Receiver might not be registered
        }
        
        // Release the wake lock if it's still held
        wakeLock?.let {
            if (it.isHeld) {
                it.release()
            }
        }
        
        // Restart the service immediately when destroyed
        val intent = Intent(this, PhoneModeService::class.java).apply {
            action = ACTION_START
        }
        
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(intent)
        } else {
            startService(intent)
        }
        
        super.onDestroy()
    }
    
    // This is called when the service is about to be killed due to low memory
    override fun onLowMemory() {
        super.onLowMemory()
        
        // Try to restart the service via alarm manager
        setupRestartAlarm(this)
    }
    
    // This is called when the device is low on memory and the process is in the background
    override fun onTrimMemory(level: Int) {
        super.onTrimMemory(level)
        
        // If being trimmed due to low memory condition, try to restart
        if (level >= TRIM_MEMORY_BACKGROUND) {
            setupRestartAlarm(this)
        }
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val serviceChannel = NotificationChannel(
                CHANNEL_ID,
                "Phone Mode Control Service",
                NotificationManager.IMPORTANCE_HIGH // Use HIGH importance to reduce chance of being killed
            ).apply {
                lightColor = Color.BLUE
                lockscreenVisibility = Notification.VISIBILITY_PUBLIC
                setShowBadge(false)
                enableVibration(false)
                enableLights(false)
            }
            notificationManager.createNotificationChannel(serviceChannel)
        }
    }

    private fun createNotification(message: String): Notification {
        // Create an intent for stopping the service
        val stopIntent = Intent(this, PhoneModeService::class.java).apply {
            action = ACTION_STOP
        }
        val stopPendingIntent = PendingIntent.getService(
            this, 0, stopIntent,
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
            } else {
                PendingIntent.FLAG_UPDATE_CURRENT
            }
        )
        
        // Create main application intent
        val mainIntent = packageManager.getLaunchIntentForPackage(packageName)
        val pendingIntent = if (mainIntent != null) {
            PendingIntent.getActivity(
                this, 0, mainIntent,
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
                } else {
                    PendingIntent.FLAG_UPDATE_CURRENT
                }
            )
        } else {
            null
        }
        
        val notificationBuilder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(this, CHANNEL_ID)
        } else {
            Notification.Builder(this).setPriority(Notification.PRIORITY_MAX)
        }
        
        return notificationBuilder
            .setContentTitle("Nexus Phone Mode")
            .setContentText(message)
            .setSmallIcon(android.R.drawable.ic_lock_silent_mode)
            .setContentIntent(pendingIntent)
            .setOngoing(true) // Mark as persistent, cannot be dismissed
            .addAction(android.R.drawable.ic_menu_close_clear_cancel, "Stop", stopPendingIntent)
            .build()
    }

    private fun startScheduler() {
        scheduler?.scheduleAtFixedRate({
            checkAndApplyRules()
        }, 0, 1, TimeUnit.MINUTES)
    }

    private fun loadRulesFromSharedPreferences() {
        val sharedPreferences = getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val rulesJson = sharedPreferences.getString("flutter.phone_mode_rules", "[]")
        updateRules(rulesJson ?: "[]")
    }

    private fun updateRules(rulesJson: String) {
        try {
            rules = JSONArray(rulesJson)
            checkAndApplyRules()
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun checkAndApplyRules() {
        // Get current time and day of week
        val calendar = Calendar.getInstance()
        val currentHour = calendar.get(Calendar.HOUR_OF_DAY)
        val currentMinute = calendar.get(Calendar.MINUTE)
        
        // Java Calendar uses 1-7 for Sunday-Saturday, we need to convert to 0-6 for Monday-Sunday
        val dayOfWeek = (calendar.get(Calendar.DAY_OF_WEEK) + 5) % 7 // Convert to 0-6 (Monday-Sunday)
        
        var shouldApplyRule = false
        var targetMode = -1
        
        // Check all rules to find applicable ones
        for (i in 0 until rules.length()) {
            try {
                val rule = rules.getJSONObject(i)
                
                // Skip disabled rules
                if (!rule.optBoolean("enabled", true)) continue
                
                // Get rule times
                val startHour = rule.optInt("startTimeHour", 0)
                val startMinute = rule.optInt("startTimeMinute", 0)
                val endHour = rule.optInt("endTimeHour", 0)
                val endMinute = rule.optInt("endTimeMinute", 0)
                val mode = rule.optInt("mode", 0)
                
                // Check if rule applies to current day
                val daysArray = rule.optJSONArray("days")
                var appliesForDay = false
                
                if (daysArray != null) {
                    for (j in 0 until daysArray.length()) {
                        if (j == dayOfWeek && daysArray.optBoolean(j, false)) {
                            appliesForDay = true
                            break
                        }
                    }
                }
                
                if (!appliesForDay) continue
                
                // Check if current time is within rule time range
                val currentTime = currentHour * 60 + currentMinute
                val startTime = startHour * 60 + startMinute
                val endTime = endHour * 60 + endMinute
                
                // Handle overnight rules (end time is earlier than start time)
                if (startTime > endTime) {
                    // Rule spans overnight
                    if (currentTime >= startTime || currentTime <= endTime) {
                        shouldApplyRule = true
                        targetMode = mode
                        break
                    }
                } else {
                    // Normal rule during the same day
                    if (currentTime >= startTime && currentTime <= endTime) {
                        shouldApplyRule = true
                        targetMode = mode
                        break
                    }
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
        
        if (shouldApplyRule && targetMode != -1) {
            applyPhoneMode(targetMode)
        } else {
            // If no rule is active, reset to normal/general mode (mode 2)
            applyPhoneMode(2) // Normal mode
        }
    }

    private fun applyPhoneMode(mode: Int) {
        // Check if we have permission to change sound settings
        val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !notificationManager.isNotificationPolicyAccessGranted) {
            return
        }
        
        when (mode) {
            0 -> { // Vibrate
                audioManager.ringerMode = AudioManager.RINGER_MODE_VIBRATE
                updateNotification("Phone mode: Vibrate")
            }
            1 -> { // Silent
                audioManager.ringerMode = AudioManager.RINGER_MODE_SILENT
                updateNotification("Phone mode: Silent")
            }
            2 -> { // Normal
                audioManager.ringerMode = AudioManager.RINGER_MODE_NORMAL
                updateNotification("Phone mode: Normal")
            }
        }
    }

    private fun updateNotification(message: String) {
        notificationManager.notify(NOTIFICATION_ID, createNotification(message))
    }
} 