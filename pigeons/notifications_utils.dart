import 'package:pigeon/pigeon.dart';

// #docregion config
@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/src/pigeons/notifications_utils.gen.dart',
  swiftOut: 'ios/Classes/NotificationsUtilsInterface.swift',
  kotlinOut: 'android/src/main/kotlin/com/zemlyanikin_maksim/notifications_utils/NotificationsUtilsInterface.kt',
  kotlinOptions: KotlinOptions(package: 'com.zemlyanikin_maksim.notifications_utils'),
))
// #enddocregion config

// On android and ios notification id has different types.
class NotificationId {
  NotificationId({
    this.androidId,
    this.iosId,
    this.androidTag,
  });

  final int? androidId;
  final String? iosId;
  final String? androidTag;
}

/// Notification payload class.
///
/// `UNNotificationContent` on iOS.
/// `Notification` on Android.
class DeliveredNotification {
  DeliveredNotification({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.threadIdentifier,
    required this.payload,
    required this.androidTag,
  });

  // `UNNotificationContent.identifier` on iOS and MacOS.
  // `StatusBarNotification.id` on Android.
  final NotificationId id;

  // `UNNotificationContent.title` on iOS and MacOS.
  // `Notification.extras['android.title']` on Android.
  final String title;

  // `UNNotificationContent.body` on iOS and MacOS.
  // `Notification.extras['android.text']` on Android.
  final String body;

  // `UNNotificationContent.subtitle` on iOS and MacOS.
  // Empty on Android.
  final String subtitle;

  // `threadIdentifier` on iOS and MacOS.
  // Empty on Android.
  final String threadIdentifier;

  /// Notification payload.
  ///
  /// Usually a map of strings to some primitive types.
  // `userInfo` on iOS.
  // `Notification.extras` on Android.
  final Map payload;

  // `Notification.tag` on Android.
  final String androidTag;
}

@HostApi()
abstract class NotificationsUtils {
  /// Returns a list of notifications that are shown in the notification center.
  @async
  List<DeliveredNotification> getDeliveredNotifications();

  /// Removes the specified notifications from the notification center.
  void removeDeliveredNotifications(List<NotificationId> ids);
}
