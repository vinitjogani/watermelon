package com.firebrick.calendar_ringer

import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.provider.Settings
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.firebrick.calendar_ringer/dnd"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        val mNotificationManager = activity.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "dnd_request") {
                // Check if the notification policy access has been granted for the app.
                if (!mNotificationManager.isNotificationPolicyAccessGranted) {
                    val intent = Intent(Settings.ACTION_NOTIFICATION_POLICY_ACCESS_SETTINGS)
                    startActivity(intent)
                }
                result.success(mNotificationManager.isNotificationPolicyAccessGranted)
            } else if (call.method == "dnd_check") {
                result.success(mNotificationManager.isNotificationPolicyAccessGranted)
            }
        }
    }
}
