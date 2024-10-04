import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crop_image/crop_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s_chat/screens/chat_screens/allUsers.dart';
import 'package:s_chat/screens/chat_screens/notification_page.dart';
import 'package:s_chat/screens/home_screens/home_screens.dart';

import '../chat_screens/messages_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController searchingChatController = TextEditingController();
  bool isDark = false;
  CameraDescription? firstCamera;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  @override
  void initState() {
    initializePage();
    super.initState();
  }

  initializePage() async {
    userConversation();
    initCamera();
  }

  initCamera() async {
    print('abcdef');
    final cameras = await availableCameras();
    print('camear : $cameras');
    setState(() {
      firstCamera = cameras.first;
    });
  }

  navigateToTakePictureScreen(BuildContext context) {
    print('firstCamera $firstCamera');
    if (firstCamera != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TakePictureScreen(camera: firstCamera!),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('errror Camera is not availble')));
    }
  }

  userConversation() {
    var conversation = _fireStore.collection('chat_room').doc();
    if (conversation.id.isNotEmpty) {
      return conversation.snapshots().length;
    }
  }

  @override
  Widget build(BuildContext context) {
    // final camera = await availableCameras();
    // final firstCamera = camera.first;
    final ThemeData themeData = ThemeData(
        useMaterial3: true,
        brightness: isDark ? Brightness.dark : Brightness.light);
    return MaterialApp(
      theme: themeData,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 15,
          // leading: Center(
          //     child: Avatar(
          //   radius: 20,
          //   url: Helpers.randomPictureUrl(),
          // )) ,
          // title: const Text('S_Chat¯_ツ_¯ ❤'),
          title: const Text(' ¯_ツ_¯'),
          actions: [
            IconButton(
                onPressed: () {
                  // TakePictureScreen(
                  //   camera: firstCamera!,
                  // );
                  navigateToTakePictureScreen(context);
                  // PermissionHandling().getFromGallery(context);
                },
                icon: const Icon(Icons.camera_alt_outlined)),
            IconButton(onPressed: () {Get.to(NotificationPage());}, icon: const Icon(Icons.notifications)),
            // IconButton(
            //     onPressed: () {}, icon: const Icon(Icons.more_vert_outlined))
            PopupMenuButton<String>(
              onSelected: (value) {
                print(value);
              },
              itemBuilder: (BuildContext contesxt) {
                return [
                  const PopupMenuItem(
                    value: "New group",
                    child: Text("New group"),
                  ),
                  const PopupMenuItem(
                    value: "New broadcast",
                    child: Text("New broadcast"),
                  ),
                  const PopupMenuItem(
                    value: "Whatsapp Web",
                    child: Text("Whatsapp Web"),
                  ),
                  const PopupMenuItem(
                    value: "Starred messages",
                    child: Text("Starred messages"),
                  ),
                  const PopupMenuItem(
                    value: "Settings",
                    child: Text("Settings"),
                  ),
                ];
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchAnchor(builder:
                    (BuildContext context, SearchController controller) {
                  return SearchBar(
                    controller: controller,
                    padding: const MaterialStatePropertyAll<EdgeInsets>(
                        EdgeInsets.symmetric(horizontal: 16.0)),
                    onTap: () {
                      controller.openView();
                    },
                    onChanged: (_) {
                      controller.openView();
                    },
                    leading: const Icon(Icons.search),
                    trailing: <Widget>[
                      Tooltip(
                        message: 'Change brightness mode',
                        child: IconButton(
                          isSelected: isDark,
                          onPressed: () {
                            setState(() {
                              isDark = !isDark;
                            });
                          },
                          icon: const Icon(Icons.wb_sunny_outlined),
                          selectedIcon: const Icon(Icons.brightness_2_outlined),
                        ),
                      )
                    ],
                  );
                }, suggestionsBuilder:
                    (BuildContext context, SearchController controller) {
                  return List<ListTile>.generate(4, (int index) {
                    final String item = 'item $index';
                    return ListTile(
                      title: Text(item),
                      onTap: () {
                        setState(() {
                          controller.closeView(item);
                        });
                      },
                    );
                  });
                }),
                // RoundTextField(
                //   onPressed: () {},
                //   controller: searchingChatController,
                //   textbackgroundColor: Colors.transparent,
                //   hintText: "Search here..!",
                //   width: double.infinity,
                // ),
                // CustomScrollView(slivers: [SliverToBoxAdapter(child: Stories())]),
                _buildUserList()
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white12,
          elevation: 0,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => const AllUsers()));
          },
          child: const Icon(Icons.contact_page_outlined),
          // child: IconBackground(icon: Icons.contact_page_outlined, onTap: () {}),
        ),
      ),
    );
  }

  Widget _buildUserList() {
    final ref = FirebaseFirestore.instance.collection('chat_room').doc();

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        // stream: ref.snapshots(),
        builder: (context, snapshots) {
          if (snapshots.hasError) {
            return const Text('error while building userList');
          }

          if (snapshots.connectionState == ConnectionState.waiting) {
            return const Center(child: Text('Loading'));
          }
          // print('dataListLength: ${snapshots.data!.docs.length}');
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              shrinkWrap: true,
              children: snapshots.data!.docs
                  .map<Widget>((doc) => snapshots.data!.docs.length == 0
                      ? Center(child: Text("Empty Chat List Data1111"))
                      : _buildUserListItem(doc))
                  .toList(),
            ),
          );
        });
  }

  _buildUserListItem(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data =
        documentSnapshot.data()! as Map<String, dynamic>;
    return (_auth.currentUser!.email != data['email'])
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
              title: Text(data['displayName']), //photoURL
              onTap: () {
                Get.to(MessagePage(
                  receiverEmail: data['email'],
                  uid: data['uid'],
                  receiverName: data['displayName'],
                  photoURL: data['photoURL'],
                ));
              },
            ))
        : const SizedBox();
  }
}

/// Mutltiple Camera acces for global use of that
///

// A screen that allows users to take a picture using a given camera.


// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();

            if (!context.mounted) return;

            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  imagePath: image.path,
                ),
              ),
            );
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  DisplayPictureScreen({super.key, required this.imagePath});

  final cropController = CropController(
    aspectRatio: 0.7,
    defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
  );

  Future cropImage() async {}

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Display the Picture')),
        // The image is stored as a file on the device. Use the `Image.file`
        // constructor with the given path to display the image.
        body: CropImage(
            controller: cropController,
            paddingSize: 25.0,
            alwaysMove: true,
            minimumImageSize: 500,
            maximumImageSize: 500,
            image: Image.file(File(imagePath))),

        bottomNavigationBar: _buildButtons(context),
      );

  _buildButtons(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              cropController.rotation = CropRotation.up;
              cropController.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
              cropController.aspectRatio = 1.0;
              Get.back();
            },
          ),
          IconButton(
            icon: const Icon(Icons.aspect_ratio),
            onPressed: () {
              _aspectRatios(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.rotate_90_degrees_ccw_outlined),
            onPressed: _rotateLeft,
          ),
          IconButton(
            icon: const Icon(Icons.rotate_90_degrees_cw_outlined),
            onPressed: _rotateRight,
          ),
          TextButton(
            onPressed: () {
              _finished(context);
            },
            child: const Text('Done'),
          ),
        ],
      );

  _aspectRatios(BuildContext context) async {
    final value = await showDialog<double>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Select aspect ratio'),
          children: [
            // special case: no aspect ratio
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, -1.0),
              child: const Text('free'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 1.0),
              child: const Text('square'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 2.0),
              child: const Text('2:1'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 1 / 2),
              child: const Text('1:2'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 4.0 / 3.0),
              child: const Text('4:3'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 16.0 / 9.0),
              child: const Text('16:9'),
            ),
          ],
        );
      },
    );
    if (value != null) {
      cropController.aspectRatio = value == -1 ? null : value;
      cropController.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
    }
  }

  _rotateLeft() async => cropController.rotateLeft();

  _rotateRight() async => cropController.rotateRight();

  _finished(BuildContext context) async {
    final image = await cropController.croppedImage();
    await showDialog<bool>(
      context: Get.context!,
      builder: (context) {
        return SimpleDialog(
          contentPadding: const EdgeInsets.all(6.0),
          titlePadding: const EdgeInsets.all(8.0),
          title: const Text('Cropped image'),
          children: [
            Text('relative: ${cropController.crop}'),
            Text('pixels: ${cropController.cropSize}'),
            const SizedBox(height: 5),
            image,
            TextButton(
              onPressed: () => Navigator.pushAndRemoveUntil(
                  context, MaterialPageRoute(builder: (_) => const HomeScreen()), (route) {return false;} ),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

/// Globally intance for maanaging the code ram structure
