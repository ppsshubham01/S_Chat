import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'setting_page_controller.dart';

class SettingPage extends GetView<SettingPageController> {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingPageController>(
      init: SettingPageController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.black12,
          appBar: AppBar(
            backgroundColor: Colors.black26,
            title: const Text('Typography'),
            actions: [
              DropdownButton(
                items: [
                  DropdownMenuItem(
                    value: '0',
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(
                              controller.user.value?.photoURL ??
                                  'https://source.unsplash.com/random'),
                        ),
                        const SizedBox(width: 3),
                        Text(controller.user.value?.displayName
                                ?.split(' ')
                                .first ??
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
                  controller.updateDropdownValue(val);
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
                          padding: const EdgeInsets.symmetric(horizontal: 40),
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
                                            child: const Text('NO'),
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
                                            onPressed: () {
                                              controller.signOut();
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
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(11)),
                        height: 130,
                        width: double.infinity,
                        child: Image.network(
                            'https://source.unsplash.com/random',
                            fit: BoxFit.fill),
                      ),
                      Column(
                        children: [
                          const SizedBox(height: 80),
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
                                      controller.user.value?.photoURL ??
                                          'https://source.unsplash.com/random',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                );
                              },
                              child: CircleAvatar(
                                radius: 65,
                                backgroundImage: NetworkImage(
                                    controller.user.value?.photoURL ??
                                        'https://source.unsplash.com/random'),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Center(
                              child: Text(controller.user.value?.displayName ??
                                  'No Name is there')),
                          Center(
                              child: Text(controller.user.value?.email ??
                                  'No email is there')),
                        ],
                      ),
                      Positioned(
                        bottom: 30,
                        right: 172,
                        child: IconButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Tapped Success')));
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
                              child: Icon(Icons.edit, color: Colors.black),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text("Profile",
                          style:
                              TextStyle(color: Colors.lightBlue, fontSize: 20)),
                      IconButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Tapped Success')));
                        },
                        color: Colors.black38,
                        icon: const Icon(Icons.edit),
                      )
                    ],
                  ),
                  Container(
                    color: Colors.black26,
                    child: Column(
                      children: [
                        buildSettingItem(Icons.perm_identity_outlined,
                            "Personal Data", () {}),
                        buildSettingItem(
                            Icons.language_outlined, "Language", () {}),
                        buildSettingItem(
                            Icons.notifications, "Notification", () {}),
                        buildSettingItem(
                            Icons.contrast_outlined, "Theme", () {}),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text("Security",
                      style: TextStyle(color: Colors.lightBlue, fontSize: 20)),
                  const SizedBox(height: 5),
                  Container(
                    color: Colors.black26,
                    child: Column(
                      children: [
                        buildSettingItem(
                            Icons.password_sharp, "Password", () {}),
                        buildSettingItem(Icons.privacy_tip_outlined,
                            "Privacy Policy", () {}),
                                            buildSettingItem(
                            Icons.contrast_outlined, "Theme", () {}),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildSettingItem(IconData icon, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
      ),
    );
  }
}
