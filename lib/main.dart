import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:s_chat/screens/auth_screens/auth_gate.dart';
import 'package:s_chat/services/auth_services/auth_services.dart';
import 'package:s_chat/theme.dart';
import 'firebase_options.dart';
import 'model/notes_models/noteM.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  Directory  appDocumentDire = await getApplicationDocumentsDirectory();
  // Hive.init(appDocumentDire.path);
  Hive..init(appDocumentDire.path)..registerAdapter(NotesModelAdapter());
  await Hive.initFlutter();
  await Hive.openBox('noteBox');

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  FlutterNativeSplash.remove();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(AuthServicesController());
  runApp(MyApp(
    appTheme: AppTheme(),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required this.appTheme});

  final AppTheme appTheme;
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: appTheme.light,
      theme: ThemeData(
          useMaterial3: true,
          brightness: isDark ? Brightness.dark : Brightness.light),
      // darkTheme: appTheme.dark,
      themeMode: ThemeMode.light,
      home: const AuthGate(),
      // getPages: AppRoutes.appRoutes(),
    );
  }
}
