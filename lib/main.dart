import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s_chat/res/routes/routes.dart';
import 'package:s_chat/screens/auth_screens/login_screen.dart';
import 'package:s_chat/screens/auth_screens/signUp_screen.dart';
import 'package:s_chat/screens/auth_screens/welcom_phone_auth.dart';
// import 'firebase_options.dart';

Future<void> main() async {
    // WidgetsFlutterBinding.ensureInitialized();
    // await Firebase.initializeApp(
    //   // options: DefaultFirebaseOptions.currentPlatform,
    // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const PhoneAuth(),
      getPages: AppRoutes.appRoutes(),
    );
  }
}
