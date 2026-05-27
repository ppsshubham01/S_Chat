import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widget/comman.dart';
import '../widget/global_widget.dart';
import '../widget/home_custom_scaffold_widget.dart';
import 'home_page/home_page.dart';
import 'music_screen/audio_page.dart';
import 'news_page/news_page.dart';
import 'notes_page/edit_notes_page.dart';
import 'notes_page/notes_page.dart';
import 'notification_service/notification_page.dart';
import 'setting_page/setting_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = const [
    HomePage(),
    NotesPage(),
    NewsPage(),
    SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return HomeCustomScaffoldWidget(

      isBack: false,
      centerTitle:   _selectedIndex == 0
          ? false
          : _selectedIndex == 1
          ? false
          : _selectedIndex == 2
          ? true
          : false,
      title: Text(
        _selectedIndex == 0
            ? " ¯_ツ_¯"
            : _selectedIndex == 1
                ? "Your Notes"
                : _selectedIndex == 2
                    ? "News"
                    : "Settings",
      ),
      actions: _selectedIndex == 0
          ? [
              IconButton(
                onPressed: () => Get.to(const AudioPage()),
                icon: const Icon(Icons.music_note_outlined),
              ),
              IconButton(
                onPressed: () => GlobalWidgets().navigateToTakePictureScreen(),
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
            ]
          : _selectedIndex == 1
              ? [
                  IconButton(
                    onPressed: () async {
                      var finalData =
                          await Get.to(() => const NotesEditScreen());
                      if (finalData != null) {
                        // setState(() => notesOfList.add(finalData));
                      }
                    },
                    icon: const Icon(Icons.add),
                  ),
                  PopupMenuButton<String>(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                          value: "View Gride/List", child: Text("View")),
                      const PopupMenuItem(
                          value: "Sync with Google", child: Text("Sync")),
                    ],
                  )
                ]
              : _selectedIndex == 2
                  ? []
                  : [
                      DropdownButton(
                        items: [
                          DropdownMenuItem(
                            value: '0',
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  // backgroundImage: NetworkImage(
                                  //     controller.user.value?.photoURL ??
                                  //         'https://source.unsplash.com/random'),
                                ),
                                const SizedBox(width: 3),
                                Text(
                                    // controller.user.value?.displayName
                                    //     ?.split(' ')
                                    //     .first ??
                                    'No Name is there'),
                              ],
                            ),
                          ),
                          // Duplicate DropdownMenuItem can be removed for better UI.
                          const DropdownMenuItem(
                            value: Text('data'),
                            child: Row(
                              children: [
                                Icon(Icons.add),
                                SizedBox(width: 3),
                                Text('Add account'),
                              ],
                            ),
                          ),
                        ],
                        onChanged: (dynamic val) {
                          // GlobalWidgets().updateDropdownValue(val);
                        },
                        iconSize: 32,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      const SizedBox(width: 5),
                      IconButton(
                        tooltip: 'Log Out',
                        onPressed: () {
                          Get.dialog(
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Material(
                                        child: Column(
                                          children: [
                                            const SizedBox(height: 10),
                                            const Text("Are You Sure?",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 30)),
                                            const SizedBox(height: 15),
                                            const Text(
                                                "Do you really want to Sign out Your current account?\nYou will not able to undo this action!",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 15)),
                                            const SizedBox(height: 20),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      foregroundColor:
                                                          const Color(
                                                              0xFFBD6969),
                                                      minimumSize:
                                                          const Size(0, 45),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('NO'),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      foregroundColor:
                                                          const Color(
                                                              0xFFBD6969),
                                                      minimumSize:
                                                          const Size(0, 45),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      GlobalWidgets().signOut();
                                                    },
                                                    child: const Text('YES'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.logout),
                      ),
                    ],
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        // elevation: 2,+
        showSelectedLabels: true,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: navigateBottomBar,
        // type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_note_sharp),
            label: 'Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundImage: NetworkImage(
                'https://source.unsplash.com/random',
              ),
            ),
            label: 'UserName',
          ),
        ],
      ),
    );
  }
}
