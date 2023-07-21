package com.zemlyanikin_maksim.notifications_utils

import android.app.NotificationManager
import android.content.Context
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

class NotificationsUtilsPlugin: FlutterPlugin {
  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    val notificationManager = flutterPluginBinding.applicationContext.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
    val notificationsUtils = NotificationsUtilsImpl(notificationManager)
    val binaryMessenger = flutterPluginBinding.binaryMessenger
    NotificationsUtils.setUp(binaryMessenger, notificationsUtils)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
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

