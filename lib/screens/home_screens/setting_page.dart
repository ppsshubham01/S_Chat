import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:s_chat/res/permission/permissions.dart';

class SettingPage extends StatefulWidget {
  final User? user;

  const SettingPage({super.key, this.user});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  User? userShubham = FirebaseAuth.instance.currentUser;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black38,
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: 'Log Out',
              onPressed: () async {
                await GoogleSignIn().signOut();
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                  child: CircleAvatar(
                  radius: 55,
                  backgroundImage: NetworkImage(userShubham?.photoURL ??
                      'https://source.unsplash.com/random'),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Center(
                  child:
                      Text(userShubham?.displayName ?? 'No Name is there')),
              Center(child: Text(userShubham?.email ?? 'No email is there')),
              const Text(
                "You are Logged in successfully",
                style: TextStyle(color: Colors.lightBlue, fontSize: 32),
              ),
              const SizedBox(
                height: 16,
              ),
              const Text(
                "Profile",
                style: TextStyle(color: Colors.lightBlue, fontSize: 20),
              ),
        
              Container(
                color: Colors.black26,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {},
                        child: const Row(
                          children: [
                            Icon(Icons.perm_identity_outlined),
                            SizedBox(
                              width: 8,
                            ),
                            Text("Personal Data")
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {},
                        child: const Row(
                          children: [
                            Icon(Icons.language_outlined),
                            SizedBox(
                              width: 8,
                            ),
                            Text("Language")
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {},
                        child: const Row(
                          children: [
                            Icon(Icons.notifications),
                            SizedBox(
                              width: 8,
                            ),
                            Text("Notification")
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {},
                        child: const Row(
                          children: [
                            Icon(Icons.contrast_outlined),
                            SizedBox(
                              width: 8,
                            ),
                            Text("Theme")
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                "Security",
                style: TextStyle(color: Colors.lightBlue, fontSize: 20),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                color: Colors.black26,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {},
                        child: const Row(
                          children: [
                            Icon(Icons.password_sharp),
                            SizedBox(
                              width: 8,
                            ),
                            Text("Password")
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {},
                        child: const Row(
                          children: [
                            Icon(Icons.privacy_tip_outlined),
                            SizedBox(
                              width: 8,
                            ),
                            Text("Privacy Policy")
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {},
                        child: const Row(
                          children: [
                            Icon(Icons.logout_rounded),
                            SizedBox(
                              width: 8,
                            ),
                            Text("Log Out")
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {},
                        child: const Row(
                          children: [
                            Icon(Icons.contrast_outlined),
                            SizedBox(
                              width: 8,
                            ),
                            Text("Theme")
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              // Text("${widget.user.phoneNumber}", style: TextStyle(color: Colors.grey, ),),
            ],
          ),
        ),
      ),
    );
  }
}
