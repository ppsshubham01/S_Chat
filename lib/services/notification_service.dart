// 📁 services/notification_service.dart

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final onClickNotification = BehaviorSubject<String>();
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  // 💬 Token to manage login/logout
  static String? _fcmToken;

  /// Request notification permission (for iOS + Android 13+)
  static Future<void> requestPermission() async {
    await Permission.notification.request();
    await _firebaseMessaging.requestPermission();
  }

  /// Initialize everything (Firebase + Local)
  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) {},
    );
    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
    );

    tz.initializeTimeZones();

    // 🟡 Start Listening Firebase Messages
    // FirebaseMessaging.onMessage.listen(_handleFirebaseMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageTap);
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);
  }

  /// Tap notification
  static void onNotificationTap(NotificationResponse details) {
    if (details.payload != null) {
      onClickNotification.add(details.payload!);
    }
  }

  /// When app is running
  static Future<void> _handleFirebaseMessage(RemoteMessage message) async {
    showSmartNotification(message);
  }

  /// When app opened from notification
  static void _handleMessageTap(RemoteMessage message) {
    if (message.data['uid'] != null) {
      onClickNotification.add(message.data['uid']);
    }
  }

  /// Background handler
  static Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
    await showSmartNotification(message);
  }

  /// Show Notification (Smart Update)
  // static Future<void> showSmartNotification(RemoteMessage message) async {
  //   final title = message.notification?.title ?? '';
  //   final body = message.notification?.body ?? '';
  //   final payload = message.data['uid'] ?? '';
  //
  //   // 🛡️ Use UID's hashCode as notification ID
  //   int notificationId = payload.hashCode;
  //
  //   const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
  //     'chat_channel', 'Chat Notifications',
  //     channelDescription: 'Channel for chat message notifications',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     sound: RawResourceAndroidNotificationSound('baby'),
  //     groupKey: 'com.example.chat',
  //     playSound: true,
  //     enableVibration: true,
  //   );
  //
  //   const NotificationDetails notificationDetails = NotificationDetails(android: androidDetails);
  //
  //   await flutterLocalNotificationsPlugin.show(
  //     notificationId,
  //     title,
  //     body,
  //     notificationDetails,
  //     payload: payload,
  //   );
  // }

  static Future<void> showSmartNotification(RemoteMessage message) async {
    // 🛡️ Ignore if already system notification received
    if (message.notification == null) {
      final title = message.data['title'] ?? '';
      final body = message.data['body'] ?? '';
      final payload = message.data['uid'] ?? '';

      // 🛡️ Use UID's hashCode as notification ID
      int notificationId = payload.hashCode;

      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'chat_channel', 'Chat Notifications',
        channelDescription: 'Channel for chat message notifications',
        importance: Importance.max,
        priority: Priority.high,
        sound: RawResourceAndroidNotificationSound('baby'),
        playSound: true,
        enableVibration: true,
        icon: '@mipmap/ic_launcher', // 👈 Added line
      );

      const NotificationDetails notificationDetails =
          NotificationDetails(android: androidDetails);

      await flutterLocalNotificationsPlugin.show(
        notificationId,
        title,
        body,
        notificationDetails,
        payload: payload,
      );
    } else {
      // Agar system notification aayi hai, kuch mat karo
      print(
          '🔵 System already showing notification, skipping local notification.');
    }
  }

  /// Subscribe to notification (Login k baad call hoga)
  static Future<void> subscribeNotification() async {
    _fcmToken = await _firebaseMessaging.getToken();
    if (_fcmToken != null) {
      print("✅ Token saved: 1 $_fcmToken");
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'fcmToken': _fcmToken});
      print("✅ Token saved: $_fcmToken");
    }
  }

  /// Unsubscribe notifications (Logout k time call hoga)
  static Future<void> unsubscribeNotification() async {
    await _firebaseMessaging.deleteToken();
    _fcmToken = null;
    print("❌ Token Deleted on logout");
  }

  /// Cancel all local notifications
  static Future cancelAll() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  static Future<void> showLocalChatNotification({
    required String title,
    required String body,
    required String uid,
  }) async {
    await showSmartNotification(RemoteMessage(
      notification: RemoteNotification(
        title: title,
        body: body,
      ),
      data: {
        'uid': uid,
      },
    ));
  }
}
