// ignore_for_file: unused_local_variable, camel_case_types, unused_field, unrelated_type_equality_checks

import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class local_notification {
  local_notification();
  final _loaclNotifiactionService = FlutterLocalNotificationsPlugin();
  Future<void> intialize() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@drawable/ic_stat_cloud_download");
    const InitializationSettings settings =
        InitializationSettings(android: androidInitializationSettings);
    await _loaclNotifiactionService.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) =>
          onDidReceivedLocalNotifications(
              0, "test", "", "external_storage_action"),
    );
  }

  Future<NotificationDetails> _notificationDetails(
      int p, bool showProgress) async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails("channel_id", "channel_name",
            channelDescription: "description",
            importance: Importance.max,
            priority: Priority.max,
            showProgress: showProgress ? true : false,
            progress: p,
            maxProgress: 100,
            ongoing: true,
            channelAction: AndroidNotificationChannelAction.createIfNotExists,
            enableVibration: false,
            playSound: false);
    return NotificationDetails(android: androidNotificationDetails);
  }

  Future<void> showNotification(
      {required id,
      required title,
      required body,
      required int p,
      required bool showProgress}) async {
    final details = await _notificationDetails(p, showProgress);
    await _loaclNotifiactionService.show(id, title, body, details,
        payload: "external_storage_action");
  }

  void onDidReceivedLocalNotifications(
      int id, String? title, String? body, String? payload) async {
    if (payload != null) {
      if (payload == "external_storage_action") {}
    }
  }
}
