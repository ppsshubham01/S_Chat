import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:s_chat/main.dart';
import 'package:s_chat/screens/notification_page.dart';
import 'package:s_chat/widgets/comman.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class FirebaseApi {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  /// Function to initialize Firebase Push Notifications
  Future<void> initializeFirebaseNotifications() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    // Request permissions
    await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );


    // Handle app states and messages
    FirebaseMessaging.onMessage.listen((message) {
      handleIncomingMessages(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleIncomingMessages(message);
    });

    FirebaseMessaging.onBackgroundMessage((message) async {
      handleIncomingMessages(message);
    });

    // Initialize local notifications for the app
    await initializeLocalNotifications();
  }

  /// Handle incoming messages in different app states
  @pragma("vm:entry-point")
  Future<void> handleIncomingMessages(RemoteMessage message) async {
    if (message.notification != null) {

      // Display a local notification
      showSimpleNotification(
        title: message.notification!.title ?? 'No Title',
        body: message.notification!.body ?? 'No Body',
        payload: jsonEncode(message.data),
      );

      // Navigate to notification screen
      MyApp().navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => NotificationScreen(message: message),
        ),
      );
    }
  }

  /// Initialize local notifications for the app
  static Future<void> initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iOSSettings =
    DarwinInitializationSettings();

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iOSSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
    );
  }

  /// Handle notification taps to navigate to appropriate screen
  static void onNotificationTap(NotificationResponse response) {
    MyApp().navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => NotificationScreen(),
      ),
    );
  }

  /// Function to show a simple local notification
  static Future<void> showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'notification_id',
          'NotificationName',
          channelDescription: 's_chatter_description',
          importance: Importance.max,
          priority: Priority.high,
          sound: RawResourceAndroidNotificationSound('baby'),
        ),
      ),
      payload: payload,
    );
  }

  /// Custom notification for method channel integration
  static const platform = MethodChannel('com.example.notifications');
  Future<void> showCustomNotification(String title, String body) async {
    try {
      await platform.invokeMethod('showNotification', {
        'title': title,
        'body': body,
        'sound': 'baby',
      });
    } on PlatformException catch (e) {
      logger.e("Failed to show notification: '${e.message}'.");
    }
  }

  /// Scheduled notification setup for reminders, etc.
  static Future<void> showScheduleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    tz.initializeTimeZones();
    await flutterLocalNotificationsPlugin.zonedSchedule(
      2,
      title,
      body,
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel_id',
          'Channel Name',
          channelDescription: 'Your channel description',
          importance: Importance.max,
          priority: Priority.high,
          sound: RawResourceAndroidNotificationSound('baby'),
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }
}
