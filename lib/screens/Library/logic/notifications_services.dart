// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class Notificationservices {
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationPlugin =
//       FlutterLocalNotificationsPlugin();

//   final AndroidInitializationSettings _androidInitializationSettings =
//       AndroidInitializationSettings('logo');

//   void initialiseNotification() async {
//     final InitializationSettings initializationSettings =
//         InitializationSettings(android: _androidInitializationSettings);

//     await FlutterLocalNotificationsPlugin().initialize(initializationSettings);
//   }

//   Future<void> sendNotification(String title, String body) async {
//     AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails('channelId', 'channelName',
//             importance: Importance.max, priority: Priority.high);
//     NotificationDetails notificationDetails =
//         NotificationDetails(android: androidNotificationDetails);
//     await _flutterLocalNotificationPlugin.show(
//         0, title, body, notificationDetails);
//   }

//   void scheduleNotifs(String title, String body) async {
//     AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails('channelId', 'channelName',
//             importance: Importance.max, priority: Priority.high);
//     NotificationDetails notificationDetails =
//         NotificationDetails(android: androidNotificationDetails);

//     await _flutterLocalNotificationPlugin.periodicallyShow(
//         0, title, body, RepeatInterval.everyMinute, notificationDetails);
//   }
// }

import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationScheduler {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final AndroidInitializationSettings _androidInitializationSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  void initializeNotifications() async {
    final initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
    final bool? result = await _requestNotificationPermission();
    if (result == true) {
      InitializationSettings initializationSettings =
          InitializationSettings(android: _androidInitializationSettings);
      await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
    } else {
      log('Permission denied');
    }
  }

  Future<bool?> _requestNotificationPermission() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    return flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }

  void sendNotifications() async {
    await _flutterLocalNotificationsPlugin.show(
        1,
        "my notification",
        "Here is the notifications",
        const NotificationDetails(
            android: AndroidNotificationDetails(
          'channel id',
          'channel name',
          importance: Importance.max,
          priority: Priority.high,
        )));
  }

  Future<void> scheduleNotification(
    String title,
    String body,
    DateTime scheduledNotificationDateTime,
  ) async {
    var time = tz.TZDateTime.from(
      scheduledNotificationDateTime,
      tz.local,
    );
    log(time.toString());
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        title,
        body,
        time,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'full screen channel id',
            'full screen channel name',
            channelDescription: 'full screen channel description',
            priority: Priority.high,
            importance: Importance.high,
            fullScreenIntent: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}
