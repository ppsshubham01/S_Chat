import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:s_chat/res/components/chatMessage_box.dart';
import 'package:s_chat/res/components/round_Textfield.dart';
import 'package:s_chat/res/permission/permissions.dart';
import 'package:s_chat/services/chat_services/message_sevices.dart';

class MessagePage extends StatefulWidget {
  final String receiverEmail;
  final String receiverName;
  final String photoURL;
  final String uid;

  const MessagePage(
      {super.key,
      required this.receiverEmail,
      required this.uid,
      required this.receiverName,
      required this.photoURL});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final MessageServices _messageServices = MessageServices();
  File? galleryFile;
  final picker = ImagePicker();

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _messageServices.sendMessage(
          widget.uid, _messageController.text, widget.receiverName);
      _messageController.clear();
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: const Icon(Icons.exit_to_app_outlined),
                onPressed: () {
                  exit(0);
                },
                tooltip: 'Exit App',
              ),
            ),
          ]),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple[900],
              ),
              accountName: Text(widget.receiverName),
              accountEmail: Text(widget.receiverEmail),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(widget.photoURL),
              ),
              onDetailsPressed: () {},
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text("delete"),
              subtitle: const Text("Delete chat from of this account"),
              onTap: () async {
                _messageServices.deleteMessages(widget.uid,
                    _firebaseAuth.currentUser!.uid, widget.receiverName);
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          //message
          Expanded(child: _buildMessageList()),
          //userInput
          _buildMessageInput(),
        ],
      ),
      // bottomNavigationBar: _buildMessageInput(),
    );
  }

  //build message list
  Widget _buildMessageList() {
    return StreamBuilder(
        stream: _messageServices.getMessages(
            widget.uid, _firebaseAuth.currentUser!.uid, widget.receiverName),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Loading');
          }

          return ListView(
            children: snapshot.data!.docs
                .map((document) => _buildMessageItem(document))
                .toList(),
          );
        });
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

    var alignment = (data['SenderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        alignment: alignment,
        child: Column(
          crossAxisAlignment:
              (data['SenderId'] == _firebaseAuth.currentUser!.uid)
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
          mainAxisAlignment:
              (data['SenderId'] == _firebaseAuth.currentUser!.uid)
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
          children: [
            // Text(data['SenderEmail']),
            Text(data['SenderName'].split(' ').first ??
                'Unknown'), //isuuue on Name display

            ChatMessageBox(message: data['message']),
          ],
        ),
      ),
    );
  }

  //build message input
  Widget _buildMessageInput() {
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
              controller: _messageController,
              hintText: 'Enter Message',
              obscureText: false,
            ),
          )),
          IconButton(
              onPressed: () {
                // PermissionHandling().requestPermission();
                _showPicker(context: context);
              },
              icon: const Icon(Icons.camera_alt_outlined)),
          IconButton(
              onPressed: sendMessage,
              icon: const Icon(Icons.arrow_upward_sharp))
        ],
      ),
    );
  }

  void _showPicker({
    required BuildContext context,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
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

                  print(
                      'cameraPermission: ${cameraPermission.status.toString()}');
                  inspect(cameraPermission.status.toString());
                  if (await cameraPermission.isDenied) {
                    final result = await cameraPermission.request();
                    print("result $result");

                    if (result.isGranted) {
                      getImage(ImageSource.camera);
                    } else if (result.isDenied) {
                      openAppSettings();
                    } else if (result.isPermanentlyDenied) {
                      // openAppSettings();
                      // ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
                      //     const SnackBar(content: Text('permission is selected')));
                    }
                  } else {
                    openAppSettings();
                    ScaffoldMessenger.of(context).showSnackBar(
                        // is this context <<<
                        const SnackBar(
                            content: Text('Grant Camera Permission!')));
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future getImage(
    ImageSource img,
  ) async {
    final pickedFile = await picker.pickImage(source: img);
    XFile? xfilePick = pickedFile;
    setState(
      () {
        if (xfilePick != null) {
          galleryFile = File(pickedFile!.path);
          ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('Is selected')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }
}
