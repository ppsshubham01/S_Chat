import 'package:flutter/material.dart';
import 'package:s_chat/screens/home_screens/home_page.dart';
import 'package:s_chat/screens/home_screens/news_page.dart';
import 'package:s_chat/screens/home_screens/notes_page.dart';
import 'package:s_chat/screens/home_screens/setting_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ValueNotifier<int> valueNotifier = ValueNotifier(0);
  int _selectedIndex = 0;

  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List _pages = const [
    HomePage(),
    NotesPage(),
    NewsPage(),
    SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          elevation: 2,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          onTap: (val) {
            navigateBottomBar(val);
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline_rounded), label: 'Chat'),
            BottomNavigationBarItem(
                icon: Icon(Icons.edit_note_sharp), label: 'Notes'),
            BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: 'news'),
            BottomNavigationBarItem(
                icon: CircleAvatar(
                  backgroundImage:
                      NetworkImage('https://source.unsplash.com/random'),
                ),
                label: 'UserName'),
          ]),
    );
  }
}
