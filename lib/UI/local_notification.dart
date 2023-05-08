// ignore_for_file: unused_local_variable, camel_case_types, unused_field

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class local_notification {
  local_notification();
  final _loaclNotifiactionService = FlutterLocalNotificationsPlugin();
  Future<void> intialize() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@drawable/ic_stat_cloud_download");
    const InitializationSettings settings =
        InitializationSettings(android: androidInitializationSettings);
    await _loaclNotifiactionService.initialize(settings);
  }

  Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails("channel_id", "channel_name",
            channelDescription: "description",
            importance: Importance.max,
            priority: Priority.max,
            playSound: true);
    return const NotificationDetails(android: androidNotificationDetails);
  }

  Future<void> showNotification(
      {required id, required title, required body}) async {
    final details = await _notificationDetails();
    await _loaclNotifiactionService.show(id, title, body, details);
  }

  void onDidReceivedLocalNotifications(
      int id, String? title, String? body, String? payload) {}
}
