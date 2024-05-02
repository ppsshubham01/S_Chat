import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../res/widgets/widgets.dart';
import 'package:get/get.dart';

class SettingPage extends StatefulWidget {
  final User? user;

  const SettingPage({super.key, this.user});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  User? userShubham = FirebaseAuth.instance.currentUser;

  dynamic dropdownValue = const Avatar(
    radius: 22,
    url: "https://source.unsplash.com/random",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        backgroundColor: Colors.black26,
        title: const Text('typography'),
        actions: [
          DropdownButton(
            items: [
              DropdownMenuItem(
                value: '0',
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(userShubham?.photoURL ??
                          'https://source.unsplash.com/random'),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(userShubham?.displayName?.split(' ').first ??
                        'No Name is there')
                  ],
                ),
              ),
              DropdownMenuItem(
                value: '0',
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(userShubham?.photoURL ??
                          'https://source.unsplash.com/random'),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(userShubham?.displayName?.split(' ').first ??
                        'No Name is there')
                  ],
                ),
              ),
              DropdownMenuItem(
                value: '0',
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(userShubham?.photoURL ??
                          'https://source.unsplash.com/random'),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(userShubham?.displayName?.split(' ').first ??
                        'No Name is there')
                  ],
                ),
              ),
              const DropdownMenuItem(
                value: Text('data'),
                child: Row(
                  children: [
                    Icon(Icons.add),
                    SizedBox(
                      width: 3,
                    ),
                    Text('Add account'),
                  ],
                ),
              ),
            ],
            // value: ,
            onChanged: (dynamic val) {
              setState(() {
                dropdownValue = val;
              });
            },
            iconSize: 32,
            // isExpanded: true,
            borderRadius: BorderRadius.circular(22),
          ),
          const SizedBox(
            width: 5,
          ),
          IconButton(
              tooltip: 'Log Out',
              onPressed: () {
                Get.dialog(
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Material(
                              child: Column(
                                children: [
                                  const SizedBox(height: 10),
                                  const Text(
                                    "Are You Sure?",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 30),
                                  ),
                                  const SizedBox(height: 15),
                                  const Text(
                                    "Do you really want to Sign out Your current account?\nYou will not able to undo this action!",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  const SizedBox(height: 20),
                                  //Buttons
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor:
                                                const Color(0xFFBD6969),
                                            minimumSize: const Size(0, 45),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            'NO',
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor:
                                                const Color(0xFFBD6969),
                                            minimumSize: const Size(0, 45),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          onPressed: () async {
                                            await GoogleSignIn().signOut();
                                            FirebaseAuth.instance.signOut();
                                            Get.back();
                                          },
                                          child: const Text(
                                            'YES',
                                          ),
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
              icon: const Icon(Icons.logout))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                // alignment: AlignmentDirectional.bottomCenter,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(11),
                    ),
                    height: 130,
                    width: double.infinity,
                    child: Image.network(
                      'https://source.unsplash.com/random',
                      fit: BoxFit.fill,
                    ),
                  ),
                  Column(
                    children: [
                      const SizedBox(
                        height: 80,
                      ),
                      CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.grey,
                        child: GestureDetector(
                          onTap: () {
                            Get.dialog(
                                useSafeArea: true,
                                barrierDismissible: true,
                                Container(
                                  margin: const EdgeInsets.all(22),
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: Image.network(
                                    // userShubham?.photoURL ??
                                    'https://source.unsplash.com/random',
                                    fit: BoxFit.contain,
                                  ),
                                ));
                          },
                          child: CircleAvatar(
                            radius: 65,
                            backgroundImage: NetworkImage(
                                userShubham?.photoURL ??
                                    'https://source.unsplash.com/random'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Center(
                          child: Text(
                              userShubham?.displayName ?? 'No Name is there')),
                      Center(
                          child:
                              Text(userShubham?.email ?? 'No email is there')),
                    ],
                  ),
                  Positioned(
                      bottom: 30,
                      right: 172,
                      child: IconButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Tapped Success')));
                        },
                        color: Colors.red,
                        icon: GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Tapped Success for Edit option!')));
                          },
                          child: const CircleAvatar(
                            backgroundColor: Colors.white24,
                            child: Icon(
                              Icons.edit,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ))
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Profile",
                    style: TextStyle(color: Colors.lightBlue, fontSize: 20),
                  ),
                  IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Tapped Success')));
                      },
                      color: Colors.black38,
                      icon: const Icon(Icons.edit))
                ],
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
                      padding: const EdgeInsets.all(8.0),
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
