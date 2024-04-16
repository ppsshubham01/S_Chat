import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:s_chat/res/components/round_button.dart';
import 'package:s_chat/screens/home_screens/setting_page.dart';

class OtpScreen extends StatefulWidget {
  String verificationID;

  OtpScreen({super.key, required this.verificationID});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OTP Scrren"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  hintText: "enter OTP here"),
              controller: otpController,
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          RoundButton(
              title: "Login",
              onPress: () async {
                try {
                  PhoneAuthCredential credential =
                      await PhoneAuthProvider.credential(
                          verificationId: widget.verificationID,
                          smsCode: otpController.text.toString());
                  FirebaseAuth.instance.signInWithCredential(credential).then((value) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const SettingPage()));
                  });
                } catch (ex) {
                  // log(ex.toString());
                  print(ex);
                }
              })
        ],
      ),
    );
  }
}
