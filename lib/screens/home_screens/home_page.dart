import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s_chat/screens/chat_screens/allUsers.dart';

import '../chat_screens/messages_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController searchingChatController = TextEditingController();
  bool isDark = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userConversation();
  }

  userConversation() {
    var conversation = _firestore.collection('chat_room').doc();
    if (conversation.id.isNotEmpty) {
      return conversation.snapshots().length;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                onPressed: () {}, icon: const Icon(Icons.camera_alt_outlined)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
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
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AllUsers()));
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
                  .map<Widget>((doc) => _buildUserListItem(doc))
                  .toList(),
            ),
          );
        });
  }

  Widget _buildUserListItem(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;
    if (_auth.currentUser!.email != data['email']) {
      return Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.redAccent, borderRadius: BorderRadius.circular(22)),
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
        ),
      );
    }
    return const Center(child: Text("Empty Chat List Data"));
    return Container();
  }
}

/// Globally intance for maanaging the code ram structure