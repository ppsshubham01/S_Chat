import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s_chat/res/components/round_button.dart';
import 'package:s_chat/screens/auth_screens/signUp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();


  void signIn(){}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Login scree'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                filled: true,
                fillColor: Colors.grey[200],
                hintText: 'Enter Email Address',
              ),
              controller: _emailController,
              keyboardType: TextInputType.phone,
            ),
            SizedBox(
              height: 5,
            ),
            TextFormField(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                filled: true,
                fillColor: Colors.grey[200],
                hintText: 'Password',
              ),
              controller: _passController,
              obscureText: true,
              obscuringCharacter: '@',
              keyboardType: TextInputType.visiblePassword,
            ),
            SizedBox(
              height: 15,
            ),
            RoundButton(title: "Login", onPress: () {
              signIn;
            },height: 43,width: 100,),
            const SizedBox(
              height: 8,
            ),
            InkWell(
              onTap: (){
                Get.to(const SignupScreen());
              },
              child: const Text(
                "Register",
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
