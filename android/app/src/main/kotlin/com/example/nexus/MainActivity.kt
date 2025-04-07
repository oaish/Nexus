package com.example.nexus

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Intent
import android.content.Context
import android.os.Build
import android.app.NotificationManager
import android.provider.Settings
import android.media.AudioManager
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import android.Manifest
import org.json.JSONArray
import org.json.JSONObject
import com.example.nexus.services.PhoneModeService
import android.net.Uri
import android.os.PowerManager

class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "com.nexus.app/phone_mode"
    private val PERMISSION_REQUEST_CODE = 100

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val context = this@MainActivity

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "checkPermissions" -> {
                    result.success(hasNotificationPolicyAccess())
                }
                "requestPermissions" -> {
                    requestNotificationPolicyAccess()
                    requestIgnoreBatteryOptimization()
                    result.success(null)
                }
                "updateRules" -> {
                    val rulesJson = call.argument<String>("rules")
                    if (rulesJson != null) {
                        val intent = Intent(context, PhoneModeService::class.java).apply {
                            action = PhoneModeService.ACTION_UPDATE_RULES
                            putExtra(PhoneModeService.EXTRA_RULES, rulesJson)
                        }

                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                            context.startForegroundService(intent)
                        } else {
                            context.startService(intent)
                        }
                        result.success(true)
                    } else {
                        result.error("INVALID_RULES", "Rules data is null", null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        PhoneModeService.startService(context)
    }

    private fun hasNotificationPolicyAccess(): Boolean {
        val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            notificationManager.isNotificationPolicyAccessGranted
        } else {
            true
        }
    }

    private fun requestNotificationPolicyAccess() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (!hasNotificationPolicyAccess()) {
                val intent = Intent(Settings.ACTION_NOTIFICATION_POLICY_ACCESS_SETTINGS)
                startActivity(intent)
            }
        }
    }

    private fun requestIgnoreBatteryOptimization() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val packageName = packageName
            val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
            if (!pm.isIgnoringBatteryOptimizations(packageName)) {
                val intent = Intent().apply {
                    action = Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS
                    data = Uri.parse("package:$packageName")
                }
                startActivity(intent)
            }
        }
    }
}
