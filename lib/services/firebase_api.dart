import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:s_chat/main.dart';
import 'package:s_chat/screens/chat_screens/notification_page.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class FirebaseApi {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Function to initialize Firebase Push Notifications
  Future<void> initializeFirebaseNotifications() async {
    // Request notification permission from the user
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    final fcmToken = await firebaseMessaging.getToken();
    print('FCM Token: $fcmToken');

    final apnsToken = await firebaseMessaging.getAPNSToken();
    print('APNs Token: $apnsToken');

    /// Automatically initialize Firebase Messaging
    await FirebaseMessaging.instance.setAutoInitEnabled(true);

    /// Initialize background notifications and handle taps from the notification panel
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      handleIncomingMessages(initialMessage);
    }

    // // Handle when the app is opened from the background (notification tap)
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   handleIncomingMessages(message);
    // });

    // Handle foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        handleIncomingMessages(message);
      }
    });

    // Handle background and terminated state (merged background handler)

    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
      handleIncomingMessages(message);
    });
  }

  /// Function to handle incoming messages in the background or foreground
  @pragma("vm:entry-point")
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
  @pragma("vm:entry-point")
  static Future<void> showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    // await flutterLocalNotificationsPlugin
    //     .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
    //     ?.createNotificationChannel(androidNotificationDetails as AndroidNotificationChannel);

    print("this one is cool ");
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
        ticker: 'ticker',
        color: Colors.green,
        playSound: true,
        enableVibration: true,
        sound: RawResourceAndroidNotificationSound('baby'),
      )),
      payload: payload,
    );
  }



  static const platform = MethodChannel('com.example.notifications');

  Future<void> showCustomNotification(String title, String body) async {
    try {
      await platform.invokeMethod('showNotification', {
        'title': title,
        'body': body,
        'sound': 'baby',
      });
    } on PlatformException catch (e) {
      print("Failed to show notification: '${e.message}'.");
    }
  }


  // to schedule a local notification
  @pragma("vm:entry-point")
  static Future showScheduleNotification({
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
                'channel 3', 'your channel name',
                channelDescription: 'your channel description',
                importance: Importance.max,
                priority: Priority.high,
                ticker: 'ticker',
                sound: RawResourceAndroidNotificationSound('baby'))),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload);
  }
}
