import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
   NotificationPage({super.key,this.message});
   RemoteMessage? message;

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: Column(
        children: [
          // Text(widget.message!.notification!.title.toString()),
          // Text(widget.message!.notification!.body.toString()),
          // Text(widget.message!.data.toString()),
          if (widget.message?.notification != null)
            Text(widget.message!.notification!.title ?? 'titlle'),
          if (widget.message?.notification != null)
            Text(widget.message!.notification!.body ?? 'body'),
          Text(widget.message?.data.toString() ?? 'data'),
        ],
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
