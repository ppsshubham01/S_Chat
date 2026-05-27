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
              Obx(() => DropdownButton(
                value: controller.dropdownValue.value.isEmpty
                    ? null
                    : controller.dropdownValue.value,
                items: [
                  DropdownMenuItem(
                    value: '0',
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(
                              controller.userData['photoURL'] ??
                                  'https://source.unsplash.com/random'),
                        ),
                        const SizedBox(width: 3),
                        Text(controller.userData['name']?.split(' ').first ??
                            'No Name'),
                      ],
                    ),
                  ),
                  const DropdownMenuItem(
                    value: 'add',
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
              )),
              const SizedBox(width: 5),
              IconButton(
                tooltip: 'Log Out',
                onPressed: () {
                  Get.dialog(
                    AlertDialog(
                      title: const Text("Are You Sure?"),
                      content: const Text(
                          "Do you really want to sign out your current account?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('NO'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            controller.signOut();
                          },
                          child: const Text('YES'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
          body: Obx(
                () => SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 130,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(11),
                          image: DecorationImage(
                            image: NetworkImage(controller.userData['photoURL'] ??
                                'https://source.unsplash.com/random'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          const SizedBox(height: 80),
                          GestureDetector(
                            onTap: () {
                              // View profile photo full screen
                              Get.dialog(
                                Center(
                                  child: Image.network(
                                    controller.userData['photoURL'] ??
                                        'https://source.unsplash.com/random',
                                  ),
                                ),
                              );
                            },
                            child: CircleAvatar(
                              radius: 70,
                              backgroundImage: NetworkImage(
                                  controller.userData['photoURL'] ??
                                      'https://source.unsplash.com/random'),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(controller.userData['name'] ?? 'No Name'),
                          Text(controller.userData['email'] ?? 'No Email'),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              // Edit name
                              Get.defaultDialog(
                                title: 'Edit Name',
                                content: TextField(
                                  controller: TextEditingController(
                                      text: controller.userData['name']),
                                  onChanged: (val) {
                                    controller.updateUserName(val);
                                  },
                                  decoration:
                                  const InputDecoration(labelText: 'Name'),
                                ),
                                confirm: TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: const Text('SAVE'),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Settings Sections
                  buildSection(
                    title: 'Profile Settings',
                    items: [
                      buildSettingItem(
                        icon: Icons.perm_identity_outlined,
                        title: "Personal Data",
                        onTap: () {},
                      ),
                      buildSettingItem(
                        icon: Icons.language_outlined,
                        title: "Language",
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  buildSection(
                    title: 'Security',
                    items: [
                      buildSettingItem(
                        icon: Icons.password_sharp,
                        title: "Password",
                        onTap: () {},
                      ),
                      buildSettingItem(
                        icon: Icons.privacy_tip_outlined,
                        title: "Privacy Policy",
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildSection({required String title, required List<Widget> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.lightBlue, fontSize: 20)),
        Container(
          color: Colors.black26,
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
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
