import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s_chat/res/components/round_button.dart';
import 'package:s_chat/screens/auth_screens/auth_gate/auth_gate_controller.dart';

import '../../../controllers/variable_controller.dart';
import 'login_screen_controller.dart'; // Import the controller

class LoginScreen extends GetView<LoginScreenController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController phoneController = TextEditingController();
    final VariableController variableController = Get.put(VariableController());

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'S_Chatter ¯_ツ_¯',
            style: TextStyle(fontSize: 30),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Welcome Back Home\n it's Dad's Home..You've been missed!",
                  style: TextStyle(fontSize: 22, color: Colors.black45),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    hintText: 'Enter Phone Number',
                  ),
                  controller: phoneController,
                ),
                const SizedBox(height: 10),
                Center(
                  child: RoundButton(
                    title: "Get OTP",
                    onPress: () async {
                      final mobile = phoneController.text.trim();
                      await controller.registerUser(mobile); // Use the controller to register
                    },
                    width: 110,
                    height: 45,
                    textColor: Colors.white,
                    buttonColor: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(thickness: 3),
                Center(
                  child: variableController.isLoading.value
                      ? const CircularProgressIndicator()
                      : IconButton(
                    onPressed: () {
                      AuthGateController().signInWithGoogle();
                    },
                    icon: const Icon(
                      Icons.g_mobiledata_outlined,
                      size: 65,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    "Made with ❤ by ",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
