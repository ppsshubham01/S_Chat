// view/otp_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/variable_controller.dart';
import 'auth_gate_controller.dart';

class OTPScreen extends StatelessWidget {
  final otpController = TextEditingController();
  final AuthGateController auth = Get.find();
  final VariableController variableController = Get.find();

  OTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enter OTP")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: otpController,
              decoration: const InputDecoration(hintText: "6-digit OTP"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            Obx(() => variableController.isLoading.value
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: () => auth.verifyOTP(otpController.text),
              child: const Text("Verify OTP"),
            )),
          ],
        ),
      ),
    );
  }
}
