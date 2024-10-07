import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:s_chat/main.dart';
import 'package:s_chat/screens/chat_screens/notification_page.dart';

class FirebaseApi {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  /// Function to initialize Firebase Push Notifications
  Future<void> initializeFirebaseNotifications() async {
    // Request notification permission from the user
    await _firebaseMessaging.requestPermission(
        alert: true, sound: true, badge: true, announcement: true);

    final fcmToken = await _firebaseMessaging.getToken();
    print('FCM Token: $fcmToken');

    final apnsToken = await _firebaseMessaging.getAPNSToken();
    print('APNs Token: $apnsToken');

    /// Automatically initialize Firebase Messaging
    await FirebaseMessaging.instance.setAutoInitEnabled(true);

    /// Initialize background notifications and handle taps from the notification panel
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      handleIncomingMessages(initialMessage);
    }

    // Handle when the app is opened from the background (notification tap)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleIncomingMessages(message);
    });

    // Handle foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Received a foreground message");
      handleIncomingMessages(message);
    });

    // Handle background and terminated state (merged background handler)
    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
      handleIncomingMessages(message);
    });
  }

  /// Function to handle incoming messages in the background or foreground
  Future<void> handleIncomingMessages(RemoteMessage message) async {
    if (message.notification == null) return;

    print('Title: ${message.notification!.title}');
    print('Body: ${message.notification!.body}');
    print('Data: ${message.data}');

    // Show a simple notification with title and body
    showSimpleNotification(
      title: message.notification!.title ?? 'No Title',
      body: message.notification!.body ?? 'No Body',
      payload: jsonEncode(message.data),
    );

    MyApp().navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => NotificationScreen(message: message),
          ),
        );
  }

  /// Initialize local notifications
  static Future<void> initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iOSSettings =
        DarwinInitializationSettings();

    const LinuxInitializationSettings linuxSettings =
        LinuxInitializationSettings(defaultActionName: 'Open notification');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iOSSettings,
      linux: linuxSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
    );
  }

  /// Callback for when a local notification is tapped
  static void onNotificationTap(NotificationResponse notificationResponse) {
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
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      color: Colors.green,
      // colorized: true,
      playSound: true,
          enableVibration: true,
      sound: RawResourceAndroidNotificationSound('baby'),
    );

    // await flutterLocalNotificationsPlugin
    //     .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
    //     ?.createNotificationChannel(androidNotificationDetails as AndroidNotificationChannel);

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}
