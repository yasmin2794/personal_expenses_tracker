import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;


class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  late tz.TZDateTime scheduledDate;

  tz.TZDateTime _nextInstanceOfSelectedDay() {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      18,30 // Schedule the reminder at 6:00 PM daily
    );
    if (scheduledTime.isBefore(now)) {
      return scheduledTime.add(Duration(days: 1));
    }
    return scheduledTime;
  }

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings = const InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));
    scheduledDate = _nextInstanceOfSelectedDay();
    await scheduleReminder();
  }

  Future<void> scheduleReminder() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Daily Reminder',
      'Don\'t forget to record your expenses today!',
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          color: Colors.purple,
          colorized: true,
          ticker: 'Daily Remainder',
          playSound: true,
          priority: Priority.high,
          'expense_tracker_channel',
          'Expense Tracker',
          importance: Importance.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

}