import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:s_chat/screens/auth_screens/login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(splash: Column(
      children: [
        Center(
          child: LottieBuilder.asset("assets/lottie/animation.json"),
        )
      ],
    ), nextScreen: const LoginScreen(),backgroundColor: Colors.greenAccent,);
  }
}
