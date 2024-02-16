A Flutter package to get delivered notifications from the notification center on Android, iOS and MacOS and cancel them.

`UNUserNotificationCenter` is used on iOS and MacOS and `NotificationManager` on Android.

## Usage
Get notifications:
```dart 
List<DeliveredNotification?> notifications = await NotificationsUtils().getDeliveredNotifications();
// `whereType` is used to take only not nullable notifications. 
// That's because `pigeon` package doesn't support non-nullable generic types.
for (final notification in notifications.whereType<DeliveredNotification>())
  print(
    "id: ${notification.id}\n"
    "threadIdentifier: ${notification.threadIdentifier}\n"
    "title: ${notification.title}\n"
    "body: ${notification.body}\n"
    "payload map: ${notification.payload}\n",
    "androidTag: ${notification.androidTag}\n",
  );
```

Cancel delivered notifications:
```dart
// On Android notification id is an integer and on iOS it's a string.
// That's why NotificationId class is used.
final NotificationId notificationId = NotificationId(
  /*optional*/ androidId: 1,
  /*optional*/ iosId: "someId",
  /*optional*/ androidTag: "someTag",
);
NotificationsUtils().removeDeliveredNotifications([notificationId]);
```

## Why is it exists?
Yeah, there is already great packages for notifications such as 
[flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications) and 
[awesome_notifications](https://pub.dev/packages/awesome_notifications).

But
- the `awesome_notifications` package doesn't support canceling delivered notifications at all.
- the `flutter_local_notifications` package can only cancel notifications that were created by it.
