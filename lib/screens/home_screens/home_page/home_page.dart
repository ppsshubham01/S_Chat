import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s_chat/screens/allusers.dart';
import 'package:s_chat/screens/chat_screens/chating_page/chating_page.dart';
import 'package:s_chat/screens/music_screen/audio_page.dart';
import 'package:s_chat/screens/notification_page.dart';

import '../../../widgets/comman.dart';
import 'home_page_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());

    final ThemeData themeData = ThemeData(
      useMaterial3: true,
      brightness: controller.isDark.value ? Brightness.dark : Brightness.light,
    );

    return MaterialApp(
      theme: themeData,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 15,
          title: const Text(' ¯_ツ_¯'),
          actions: [
            IconButton(
              onPressed: () => Get.to(const AudioPage()),
              icon: const Icon(Icons.music_note_outlined),
            ),
            IconButton(
              onPressed: () => navigateToTakePictureScreen(),
              icon: const Icon(Icons.camera_alt_outlined),
            ),
            IconButton(
              onPressed: () => Get.to(NotificationScreen()),
              icon: const Icon(Icons.notifications),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                logger.e("values $value");
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem(
                      value: "New group", child: Text("New group")),
                  const PopupMenuItem(
                      value: "New broadcast", child: Text("New broadcast")),
                  const PopupMenuItem(
                      value: "Whatsapp Web", child: Text("Whatsapp Web")),
                  const PopupMenuItem(
                      value: "Starred messages",
                      child: Text("Starred messages")),
                  const PopupMenuItem(
                      value: "Settings", child: Text("Settings")),
                ];
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(),
                _buildUserList(),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white12,
          elevation: 0,
          onPressed: () {
            Get.to(() => const AllUsers());
          },
          child: const Icon(Icons.contact_page_outlined),
        ),
      ),
    );
  }

  void navigateToTakePictureScreen() {
    if (controller.firstCamera != null) {
      Get.to(() => TakePictureScreen(camera: controller.firstCamera!));
    } else {
      Get.snackbar('Error', 'Camera is not available',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Widget _buildSearchBar() {
    return SearchAnchor(
      builder: (BuildContext context, SearchController searchController) {
        return SearchBar(
          controller: searchController,
          padding: const WidgetStatePropertyAll<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: 16.0)),
          onTap: () {
            searchController.openView();
          },
          onChanged: (_) {
            searchController.openView();
          },
          leading: const Icon(Icons.search),
          trailing: [
            Tooltip(
              message: 'Change brightness mode',
              child: IconButton(
                isSelected: controller.isDark.value,
                onPressed: () {
                  controller.toggleTheme();
                },
                icon: const Icon(Icons.wb_sunny_outlined),
                selectedIcon: const Icon(Icons.brightness_2_outlined),
              ),
            )
          ],
        );
      },
      suggestionsBuilder:
          (BuildContext context, SearchController searchController) {
        return List<ListTile>.generate(4, (int index) {
          final String item = 'item $index';
          return ListTile(
            title: Text(item),
            onTap: () {
              searchController.closeView(item);
            },
          );
        });
      },
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshots) {
        if (snapshots.hasError) {
          return const Text('Error while building userList');
        }

        if (snapshots.connectionState == ConnectionState.waiting) {
          return const Center(child: Text('Loading'));
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            shrinkWrap: true,
            children: snapshots.data!.docs
                .map<Widget>((doc) => _buildUserListItem(doc))
                .toList(),
          ),
        );
      },
    );
  }

  Widget _buildUserListItem(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data =
        documentSnapshot.data()! as Map<String, dynamic>;
    return (controller.auth.currentUser!.email != data['email'])
        ? Container(
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(22)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                    data['photoURL'] ?? 'https://source.unsplash.com/random'),
              ),
              title: Text(data['displayName'] ?? 'Unknown'),
              onTap: () {
                Get.to(ChattingPage(
                  receiverEmail: data['email'],
                  uid: data['uid'] ?? '',
                  receiverName: data['displayName'] ?? 'Unknown',
                  photoURL: data['photoURL'] ?? '',
                ));
              },
            ),
          )
        : const ColoredBox(color: Colors.transparent);
  }
}

// TakePictureScreen.dart

class TakePictureScreen extends GetView<HomeController> {
  const TakePictureScreen({super.key, required this.camera});

  final CameraDescription camera;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      body: FutureBuilder<void>(
        future: controller.cameraController?.initialize(),
        // Use the camera controller from HomeController
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(controller.cameraController!);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            final image = await controller.cameraController!.takePicture();
            if (!context.mounted) return;
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    DisplayPictureScreen(imagePath: image.path),
              ),
            );
          } catch (e) {
            logger.e("Error taking picture: $e");
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display Picture')),
      body: Center(
        child: Image.file(
          File(imagePath), // Load the image from the provided path
          fit: BoxFit.cover, // Adjust the image to cover the entire screen
        ),
      ),
    );
  }
}
