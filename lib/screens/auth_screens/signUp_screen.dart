import 'package:flutter/material.dart';
import 'package:s_chat/res/components/round_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confompassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('SignUp Screen'),
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
            const SizedBox(
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
            const SizedBox(
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
                hintText: 'Conform Password',
              ),
              controller: _confompassController,
              obscureText: true,
              obscuringCharacter: '@',
              keyboardType: TextInputType.visiblePassword,
            ),
            SizedBox(
              height: 15,
            ),
            RoundButton(title: "Login", onPress: () {},height: 43,width: 100,)
          ],
        ),
      ),
    );
  }
}
