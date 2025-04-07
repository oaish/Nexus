package com.example.nexus.receivers

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import com.example.nexus.services.PhoneModeService

class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Intent.ACTION_BOOT_COMPLETED || 
            intent.action == Intent.ACTION_MY_PACKAGE_REPLACED ||
            intent.action == Intent.ACTION_LOCKED_BOOT_COMPLETED) {
            
            // Use the static method to start the service and set up alarms
            PhoneModeService.startService(context)
        }
    }
} 