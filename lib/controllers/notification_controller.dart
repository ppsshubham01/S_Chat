import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../screens/home_screens/home_page.dart';
import '../services/notification_service.dart';

class NotificationController extends GetxController {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  RxList<Map<String, dynamic>> notifications = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeFirebaseMessaging();
  }

  void _initializeFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Map<String, dynamic> notificationData = {
        'title': message.notification?.title ?? 'No Title',
        'body': message.notification?.body ?? 'No Body',
        'payload': message.data['payload'] ?? 'No Payload'
      };
      notifications.add(notificationData);

      NotificationService.simpleNotification(
        title: notificationData['title'],
        body: notificationData['body'],
        payload: notificationData['payload'],
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle notification tap when the app is opened from background
      // Get.to(HomePage(chatId: message.data['chatId']));
      Get.to(const HomePage());
    });
  }
}
