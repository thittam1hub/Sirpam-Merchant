package com.vendoros.app

import android.app.Notification
import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.BinaryMessenger

/**
 * Streams payment-app notifications (package, title, text) to Flutter.
 * The Dart side filters UPI apps, extracts credited amounts, and speaks them.
 * Enable via Settings -> Notifications -> Notification access.
 */
class UpiNotificationListener : NotificationListenerService() {

    companion object {
        private const val EVENTS = "vendoros/soundbox/events"
        private var sink: EventChannel.EventSink? = null

        /** Called once from MainActivity's engine setup path if needed; here we
         * register lazily from the service using a cached messenger. */
        fun bind(messenger: BinaryMessenger) {
            EventChannel(messenger, EVENTS).setStreamHandler(
                object : EventChannel.StreamHandler {
                    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                        sink = events
                    }

                    override fun onCancel(arguments: Any?) {
                        sink = null
                    }
                }
            )
        }
    }

    override fun onNotificationPosted(sbn: StatusBarNotification?) {
        val n = sbn?.notification ?: return
        val extras = n.extras ?: return
        val title = extras.getCharSequence(Notification.EXTRA_TITLE)?.toString() ?: ""
        val text = extras.getCharSequence(Notification.EXTRA_TEXT)?.toString() ?: ""
        val bigText = extras.getCharSequence(Notification.EXTRA_BIG_TEXT)?.toString() ?: ""
        if (title.isEmpty() && text.isEmpty() && bigText.isEmpty()) return
        sink?.success(
            mapOf(
                "package" to sbn.packageName,
                "title" to title,
                "text" to if (bigText.isNotEmpty()) bigText else text,
            )
        )
    }

    override fun onDestroy() {
        sink = null
        super.onDestroy()
    }
}
