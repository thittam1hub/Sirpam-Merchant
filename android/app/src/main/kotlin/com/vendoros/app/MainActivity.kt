package com.vendoros.app

import android.content.Intent
import android.provider.Settings
import android.text.TextUtils
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channel = "vendoros/soundbox"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Event channel for the notification-listener service.
        UpiNotificationListener.bind(flutterEngine.dartExecutor.binaryMessenger)
        // Bluetooth ESC/POS receipt printer transport.
        ThermalPrinter.attach(this)
        ThermalPrinter.bind(flutterEngine.dartExecutor.binaryMessenger, applicationContext)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "isPermissionGranted" -> result.success(isNotificationAccessGranted())
                    "openSettings" -> {
                        startActivity(
                            Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS)
                                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        )
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == ThermalPrinter.PERMISSION_REQUEST) {
            ThermalPrinter.onPermissionResult(applicationContext)
        }
    }

    override fun onDestroy() {
        ThermalPrinter.attach(null)
        super.onDestroy()
    }

    private fun isNotificationAccessGranted(): Boolean {
        val enabled = Settings.Secure.getString(
            contentResolver, "enabled_notification_listeners"
        ) ?: return false
        return !TextUtils.isEmpty(enabled) && enabled.contains(packageName)
    }
}
