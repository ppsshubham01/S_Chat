import 'dart:io';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:s_chat/res/theme.dart';
import 'package:s_chat/screens/auth_screens/auth_gate.dart';
import 'package:s_chat/services/auth_services/auth_services.dart';
import 'package:s_chat/services/firebase_api.dart';
import 'package:s_chat/services/notification_service.dart';
import 'firebase_options.dart';
import 'model/notes_models/noteM.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  await NotificationService().requestPermission();

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  Directory appDocumentDire = await getApplicationDocumentsDirectory();
  // Hive.init(appDocumentDire.path);
  ///Hive Database
  Hive
    ..init(appDocumentDire.path)
    ..registerAdapter(NotesModelAdapter());
  await Hive.initFlutter();
  await Hive.openBox('noteBox');

  ///Native SplashScreen
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  FlutterNativeSplash.remove();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(AuthServicesController());

  ///Push Notification using firebase
  await FirebaseApi().initPushNotification();

  /// Firebase Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(MyApp(
    appTheme: AppTheme(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key,  this.appTheme});

  final AppTheme? appTheme;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: appTheme.light,
      theme: ThemeData(
          useMaterial3: true,
          brightness: isDark ? Brightness.dark : Brightness.light),
      // darkTheme: appTheme.dark,
      themeMode: ThemeMode.light,
      home: const AuthGate(),
      // routes: NotificationPage
      // getPages: AppRoutes.appRoutes(),
    );
  }
}
