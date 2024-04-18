import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingPage extends StatefulWidget {
  final User? user;

  const SettingPage({super.key, this.user});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
                decoration: BoxDecoration(color: Colors.greenAccent),
                child: Text('settingUserDrawer')),
            ListTile(
              title: const Text('Home'),
              // selected: () {},
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Home 1'),
              // selected: _selectedIndex,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Home 2'),
              // selected: () {},
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),

      body: Container(
        padding: const EdgeInsets.all(32),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "You are Logged in succesfully",
              style: TextStyle(color: Colors.lightBlue, fontSize: 32),
            ),
            SizedBox(
              height: 16,
            ),
            // Text("${widget.user.phoneNumber}", style: TextStyle(color: Colors.grey, ),),
          ],
        ),
      ),
    );
  }
}
