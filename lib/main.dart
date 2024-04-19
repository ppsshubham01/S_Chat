
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:s_chat/res/routes/routes.dart';
import 'package:s_chat/theme.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory appDocumentDire = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDire.path);
  await Hive.openBox('notesHIveData');
  // await Firebase.initializeApp(
  //   // options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp( MyApp(appTheme: AppTheme(),));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.appTheme});
  final AppTheme appTheme;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
    // return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme.light,
      darkTheme: appTheme.dark,
      themeMode: ThemeMode.light,
      // home: const SplashScreen(),
      getPages: AppRoutes.appRoutes(),
    );
  }
}
