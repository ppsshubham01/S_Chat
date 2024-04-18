import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:s_chat/res/routes/routes.dart';
import 'package:s_chat/splash_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory appDocumentDire = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDire.path);
  await Hive.openBox('notesHIveData');
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
    // return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const SplashScreen(),
      getPages: AppRoutes.appRoutes(),
    );
  }
}
