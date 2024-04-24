import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

        actions: [
          IconButton(onPressed: ()async{
            await GoogleSignIn().signOut();
            FirebaseAuth.instance.signOut();
          }, icon: const Icon(Icons.power_settings_new_outlined))
        ],
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            Center(child: CircleAvatar(radius: 55,backgroundImage: NetworkImage('https://source.unsplash.com/random'),)),
            SizedBox(height: 5,),
            Center(child: Text("pps.shubham01@.com")),
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
