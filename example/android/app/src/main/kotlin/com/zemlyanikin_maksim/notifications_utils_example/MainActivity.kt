package com.zemlyanikin_maksim.notifications_utils_example

import android.app.NotificationManager
import android.content.Context
import android.os.Bundle
import android.os.PersistableBundle
import com.zemlyanikin_maksim.notifications_utils.DeliveredNotification
import com.zemlyanikin_maksim.notifications_utils.NotificationId
import com.zemlyanikin_maksim.notifications_utils.NotificationsUtils
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val notificationsUtils = NotificationsUtilsImpl(notificationManager)
//        val binaryMessenger: BinaryMessenger
//        NotificationsUtils.setUp(binaryMessenger, notificationsUtils)
        super.onCreate(savedInstanceState, persistentState)
    }
}

class NotificationsUtilsImpl(private val notificationManager: NotificationManager) : NotificationsUtils {
    override fun getDeliveredNotifications(callback: (Result<List<DeliveredNotification>>) -> Unit) {
        val deliveredNotifications = notificationManager.activeNotifications.map {
            val extras = it.notification.extras
            val payload = mutableMapOf<Any, Any?>()
            for (key in extras.keySet()) {
                payload[key] = extras.getString(key)
            }
            DeliveredNotification(
                id = NotificationId(androidId = it.id.toLong()),
                title = payload["android.title"]?.toString() ?: "",
                subtitle = "",
                body = payload["android.text"]?.toString() ?: "",
                payload = payload,
                threadIdentifier = "",
            )
        }
        callback(Result.success(deliveredNotifications));
    }

    override fun removeDeliveredNotifications(ids: List<NotificationId>) {
        for (id in ids) {
            val androidId = id.androidId
            if (androidId != null) {
                notificationManager.cancel(androidId.toInt())
            }
        }
    }
}
