import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:s_chat/services/notification_service.dart';

class NotificationPage extends StatefulWidget {
  NotificationPage({super.key, this.message});

  RemoteMessage? message;

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  @override
  void initState() {
    listenToNotifications();
    super.initState();
  }
  listenToNotifications() {
    print("Listening to notification");
    NotificationService.onClickNotification.stream.listen((event) {
      print(event);
      Navigator.pushNamed(context, '/another', arguments: event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () async{
                  await NotificationService().requestPermission();
                  NotificationService.simpleNotification(title: "Test title", body: 'test body', payload: 'test payload');
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[700]),
                child: const Text("Notify me",style: TextStyle(color: Colors.white),)),
            ElevatedButton(
                onPressed: () async{
                  await NotificationService().requestPermission();
                  NotificationService.showPeriodicNotification(
                    title: "Periodic Notification",
                    body: "This notification repeats every minute",
                    payload: "periodic_payload",
                  );
                  },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[700]),
                child: const Text("Notify me periodically",style: TextStyle(color: Colors.white),)),
            ElevatedButton.icon(
              icon: const Icon(Icons.timer_outlined),
              onPressed: () {
                NotificationService.showScheduleNotification(
                    title: "Schedule Notification",
                    body: "This is a Schedule Notification",
                    payload: "This is schedule data");
              },
              label: const Text("Schedule Notifications"),
            ),
            // to close periodic notifications
            ElevatedButton.icon(
                icon: const Icon(Icons.delete_outline),
                onPressed: () {
                  NotificationService.cancel(1);
                },
                label: const Text("Close Periodic Notifcations")),
            ElevatedButton.icon(
                icon: const Icon(Icons.delete_forever_outlined),
                onPressed: () {
                  NotificationService.cancelAll();
                },
                label: const Text("Cancel All Notifcations"))
          ],
        ),
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
