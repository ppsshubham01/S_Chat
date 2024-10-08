import 'dart:io';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:s_chat/res/theme.dart';
import 'package:s_chat/screens/auth_screens/auth_gate.dart';
import 'package:s_chat/services/firebase_api.dart';
import 'package:s_chat/services/notification_service.dart';

import 'firebase_options.dart';
import 'model/notes_models/noteM.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize Notification Service
  await NotificationService.init();
  await NotificationService().requestPermission();
  // FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
  //   FirebaseApi().handleIncomingMessages(message);
  // });

  /// Initialize Hive database
  await _initHiveDatabase();

  /// Initialize Firebase and Firebase services (FCM, Crashlytics)
  await _initFirebase();

  /// Native SplashScreen
  _setupSplashScreen();

  /// Set up global error handling for Crashlytics
  _setupCrashlytics();

  runApp(MyApp(
    appTheme: AppTheme(),
  ));
}

/// Function to initialize Hive database and open required boxes
Future<void> _initHiveDatabase() async {
  Directory appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(
      NotesModelAdapter()); // Registering the NotesModel adapter
  await Hive.initFlutter();
  await Hive.openBox('noteBox'); // Opening a box for notes storage
}

/// Function to initialize Firebase, Firebase Messaging, and handle notifications
Future<void> _initFirebase( ) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseApi().initializeFirebaseNotifications(); // Initialize Firebase Push Notifications
}

/// Set up native splash screen and handle removal after initialization
void _setupSplashScreen() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  FlutterNativeSplash.remove();
}

/// Set up Crashlytics for handling errors globally
void _setupCrashlytics() {
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Capture uncaught asynchronous errors and report to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
}

/// Main App widget with theme and navigation setup
class MyApp extends StatefulWidget {
  final AppTheme? appTheme;

  MyApp({super.key, this.appTheme});

  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: widget.navigatorKey,// Global navigator key for navigation
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness:
            isDark ? Brightness.dark : Brightness.light,
      ),
      themeMode: ThemeMode.light,
      home: const AuthGate(),
    );
  }
}
