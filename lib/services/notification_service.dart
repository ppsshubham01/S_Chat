import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    var initializationSettingsANDROID =
        const AndroidInitializationSettings('app_icon');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsANDROID, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId',
        'channelName',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        // for Ensure vibration is enabled
        sound: RawResourceAndroidNotificationSound(
            'notification'), // for Ensure you have this sound file in `res/raw/notification.mp3`
      ),
      iOS: DarwinNotificationDetails(
        sound: 'default', // or specify custom sound
      ),
    );
  }

  // Future showNotification(
  //     {int id = 0, String? title, String? body, String? payLoad}) async {
  //   return flutterLocalNotificationsPlugin.show(
  //       id, title, body, notificationDetails());
  // }

  Future<void> showNotification() async {
    // notificationDetails();
    var platformChannelSpecifics = const NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId',
        'channelName',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        // for Ensure vibration is enabled
        sound: RawResourceAndroidNotificationSound(
            'notification'), // for Ensure you have this sound file in `res/raw/notification.mp3`
      ),
      iOS: DarwinNotificationDetails(
        sound: 'default', // or specify custom sound
      ),
    );
    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      'Test Title', // Notification Title
      'Test Body', // Notification Body, set as null to remove the body
      platformChannelSpecifics,
      payload: 'New Payload', // Notification Payload
    );
  }
}
