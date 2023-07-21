import 'dart:math';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';

import 'package:notifications_utils/notifications_utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _notifications = <DeliveredNotification>[];
  final _notificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();

    _initAndGet();
  }

  Future<void> _initAndGet() async {
    await _notificationsPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
        macOS: DarwinInitializationSettings(),
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );
    _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
    await _getNotifications();
  }

  Future<void> _getNotifications() async {
    try {
      final notifications = await NotificationsUtils().getDeliveredNotifications();
      _notifications = notifications.whereType<DeliveredNotification>().toList();
      if (mounted) setState(() {});
    } catch (e, st) {
      debugPrintStack(stackTrace: st, label: e.toString());
    }
  }

  void _removeNotification(NotificationId notificationId) {
    NotificationsUtils().removeDeliveredNotifications([notificationId]);
    _getNotifications();
  }

  Future<void> _showNotification() async {
    final darwinNotificationDetails = DarwinNotificationDetails(
      subtitle: generateWordPairs().take(3).join(' '),
      threadIdentifier: generateWordPairs().take(1).join(' '),
    );
    await _notificationsPlugin.show(
      Random().nextInt(10000000),
      generateWordPairs().take(3).join(' '),
      generateWordPairs().take(3).join(' '),
      NotificationDetails(
        android: const AndroidNotificationDetails('channel id', 'channel name'),
        iOS: darwinNotificationDetails,
        macOS: darwinNotificationDetails,
      ),
      payload: generateWordPairs().take(3).join(' '),
    );
    _getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Notifications utils example'),
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              onPressed: () => _showNotification(),
              child: const Icon(Icons.add),
            ),
            const SizedBox(height: 10),
            FloatingActionButton(
              onPressed: () => _getNotifications(),
              child: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: ListView(
          children: [
            if (_notifications.isEmpty)
              const ListTile(
                title: Text('No delivered notifications'),
              ),
            for (final notification in _notifications)
              ListTile(
                onTap: () => _removeNotification(notification.id),
                leading: Text('Id:\n${notification.id.id}'),
                trailing: Text('Thread id:\n${notification.threadIdentifier}'),
                title: Text('Title: ${notification.title}. Subtitle: ${notification.subtitle}'),
                subtitle: Text('Body: ${notification.body}\nPayload: ${notification.payload}'),
              ),
          ],
        ),
      ),
    );
  }
}

extension on NotificationId {
  String get id => androidId?.toString() ?? iosId ?? 'null';
}
