import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:s_chat/res/components/chat_message_box.dart';
import 'package:s_chat/res/components/round_text_form_field.dart';
import 'package:s_chat/services/chat_services/message_sevices.dart';

import '../../../services/notification_service.dart';

class ChattingPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverName;
  final String photoURL;
  final String uid;

  const ChattingPage({
    super.key,
    required this.receiverEmail,
    required this.uid,
    required this.receiverName,
    required this.photoURL,
  });

  @override
  State<ChattingPage> createState() => ChattingPageState();
}

class ChattingPageState extends State<ChattingPage> {
  TextEditingController messageController = TextEditingController();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  MessageServices messageServices = MessageServices();
  ScrollController scrollController = ScrollController();

  File? galleryFile;
  ImagePicker picker = ImagePicker();

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
        await messageServices.sendMessage(
          widget.uid,
          messageController.text.trim(),
          widget.receiverName,
        );

      await NotificationService.showLocalChatNotification(
        title: widget.receiverName,
        body: messageController.text.trim(),
        uid: widget.uid,
      );
      messageController.clear();
      scrollToBottom();
    }
  }

  // void sendMessage() async {
  //   if (messageController.text.isNotEmpty) {
  //     // 📩 Send the message to Firebase
  //     await messageServices.sendMessage(
  //       widget.uid,
  //       messageController.text.trim(),
  //       widget.receiverName,
  //     );
  //
  //     // 🛎 Send Local Notification (For own testing)
  //     await NotificationService.showSmartNotification(
  //       RemoteMessage(
  //         notification: RemoteNotification(
  //           title: widget.receiverName,
  //           body: messageController.text.trim(),
  //         ),
  //         data: {
  //           'uid': widget.uid,
  //         },
  //       ),
  //     );
  //
  //     // 🎯 Clear message input and scroll
  //     messageController.clear();
  //     scrollToBottom();
  //   }
  // }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          widget.receiverEmail,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app_outlined),
            onPressed: () {
              exit(0);
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple[900]),
              accountName: Text(widget.receiverName),
              accountEmail: Text(widget.receiverEmail),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(widget.photoURL),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text("Delete"),
              subtitle: const Text("Delete chat from this account"),
              onTap: () async {
                await messageServices.deleteMessages(
                  widget.uid,
                  firebaseAuth.currentUser!.uid,
                  widget.receiverName,
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(child: buildMessageList()),
          buildMessageInput(),
        ],
      ),
    );
  }

  Widget buildMessageList() {
    return StreamBuilder(
      stream: messageServices.getMessages(
        widget.uid,
        firebaseAuth.currentUser!.uid,
        widget.receiverName,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollToBottom();
        });

        return ListView(
          controller: scrollController,
          padding: const EdgeInsets.symmetric(vertical: 10),
          children: snapshot.data!.docs
              .map((document) => buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  Widget buildMessageItem(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

    var isSender = data['SenderId'] == firebaseAuth.currentUser!.uid;

    var alignment = isSender ? Alignment.centerRight : Alignment.centerLeft;
    var crossAxis =
        isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        alignment: alignment,
        child: Column(
          crossAxisAlignment: crossAxis,
          children: [
            Text(
              (data['SenderName']?.split(' ').first ?? 'Unknown'),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            ChatMessageBox(message: data['message']),
          ],
        ),
      ),
    );
  }

  Widget buildMessageInput() {
    return Container(
      color: Colors.greenAccent,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RoundTextField(
                textbackgroundColor: Colors.transparent,
                onPressed: () {},
                controller: messageController,
                hintText: 'Enter Message',
                obscureText: false,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined),
            onPressed: () => showPicker(context: context),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_upward_sharp),
            onPressed: sendMessage,
          ),
        ],
      ),
    );
  }

  void showPicker({required BuildContext context}) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () async {
                  Permission cameraPermission = Permission.camera;

                  if (await cameraPermission.isDenied) {
                    var result = await cameraPermission.request();
                    if (result.isGranted) {
                      getImage(ImageSource.camera);
                    } else {
                      openAppSettings();
                    }
                  } else {
                    getImage(ImageSource.camera);
                  }

                  Navigator.of(Get.context!).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future getImage(ImageSource img) async {
    final pickedFile = await picker.pickImage(source: img);
    if (pickedFile != null) {
      galleryFile = File(pickedFile.path);
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(content: Text('Image selected')),
      );
    } else {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(content: Text('Nothing selected')),
      );
    }
  }
}
