import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s_chat/res/widgets/dialog.dart';
import 'package:s_chat/screens/chat_screens/notification_page.dart';

class FirebaseApi {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  ///instance of firebase Push notifications
  static final _firebaseMessaging = FirebaseMessaging.instance;

  ///fun to initialize notifications
  getFirebaseMessagingToken() async {
    //request permission from user (will prompt user)
    await _firebaseMessaging.requestPermission();

    //fetch FCM token for the device
    final fcmToken = await _firebaseMessaging.getToken()
    //     .then((t) {
    //   if (t != null) {print('pushToken ${t}'}
    // })
    ;
    final apnstToken = await _firebaseMessaging.getAPNSToken(); //for apple

    print('FCMToken: $fcmToken');
    // FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
    //   // Note: This callback is fired at each app startup and whenever a new
    //   // token is generated.
    // }).onError((err) {
    //   // Error getting token.
    // });
    initPushNotification();
  }

  ///Function to handle receiver message

  void handleMessages(RemoteMessage? message) {
    //if the message is null
    if (message == null) return;

    print('title: ${message.notification!.title}');
    print('title: ${message.notification!.body}');
    print('title: ${message.data}');

    Get.to(NotificationPage(
      message: message,
    ));
  }

  ///Function to initialize background setting
  Future initPushNotification() async {
    //handle notification if the app was terminated and now opened
    FirebaseMessaging.instance.getInitialMessage().then(handleMessages);

    //attach event listener for when a notification open the app
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessages);
  }
}
