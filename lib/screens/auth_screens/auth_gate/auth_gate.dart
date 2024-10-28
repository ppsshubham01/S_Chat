import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s_chat/screens/home_screens/home_screens.dart';
import 'auth_gate_controller.dart';  // Import the controller

import '../login_screen/login_screen.dart';

class AuthGate extends GetView<AuthGateController> {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AuthGateController());
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: controller.authStateChanges,
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasData) {
            return const HomeScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
