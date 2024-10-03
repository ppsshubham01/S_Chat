import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:s_chat/services/notification_service.dart';

class NotificationPage extends StatefulWidget {
  NotificationPage({super.key, this.message});

  RemoteMessage? message;

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  Future<void> requestPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () async{
              await requestPermission();
              // NotificationService().showNotification(title: 'Sample title', body: 'It works!');
              NotificationService().showNotification();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[700]),
            child: const Text("Notify me",style: TextStyle(color: Colors.white),)),
      ),
    );
  }
}

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
//
// class NotificationPage extends StatefulWidget {
//   final RemoteMessage? message;
//
//   NotificationPage({Key? key, this.message}) : super(key: key);
//
//   @override
//   State<NotificationPage> createState() => _NotificationPageState();
// }
//
// class _NotificationPageState extends State<NotificationPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Notifications'),
//       ),
//       body: Column(
//         children: [
//           if (widget.message?.notification != null)
//             Text(widget.message!.notification!.title ?? ''),
//           if (widget.message?.notification != null)
//             Text(widget.message!.notification!.body ?? ''),
//           Text(widget.message?.data.toString() ?? ''),
//         ],
//       ),
//     );
//   }
// }
//
