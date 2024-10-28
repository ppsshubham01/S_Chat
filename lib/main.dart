import 'dart:io';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:s_chat/res/theme.dart';
import 'package:s_chat/screens/auth_screens/auth_gate/auth_gate.dart';
import 'package:s_chat/screens/auth_screens/auth_gate/auth_gate_controller.dart';
import 'package:s_chat/services/firebase_api.dart';
import 'package:s_chat/services/notification_service.dart';

import 'firebase_options.dart';
import 'model/notes_models/note_.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.init();
  await NotificationService().requestPermission();

  await _initHiveDatabase();
  await _initFirebase();

  _setupSplashScreen();
  _setupCrashlytics();

  runApp(MyApp(appTheme: AppTheme()));
}

/// Initialize Hive database and open required boxes
Future<void> _initHiveDatabase() async {
  Directory appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(NotesModelAdapter());
  await Hive.initFlutter();
  await Hive.openBox('noteBox');
}

/// Initialize Firebase and Firebase services (FCM, Crashlytics)
Future<void> _initFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initializeFirebaseNotifications();
}

/// Set up native splash screen
void _setupSplashScreen() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  FlutterNativeSplash.remove();
}

/// Set up Crashlytics for handling errors globally
void _setupCrashlytics() {
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
}

/// Main App widget
class MyApp extends StatefulWidget {
  final AppTheme? appTheme;
  final navigatorKey = GlobalKey<NavigatorState>();

  MyApp({super.key, this.appTheme});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    Get.put(AuthGateController());
    return GetMaterialApp(
      navigatorKey: widget.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: isDark ? Brightness.dark : Brightness.light,
      ),
      themeMode: ThemeMode.light,
      home: const AuthGate(),
    );
  }
}
