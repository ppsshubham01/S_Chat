import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../home_screens.dart';
import 'auth_gate_controller.dart';
import 'login_screen.dart';


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
