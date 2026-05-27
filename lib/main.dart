import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s_chat/controllers/variable_controller.dart';
import 'package:s_chat/res/theme.dart';
import 'package:s_chat/screens/auth_screens/auth_gate_controller.dart';
import 'package:s_chat/services/firebase_api.dart';
import 'package:s_chat/services/notification_service.dart';

import 'firebase_options.dart';
import 'screens/auth_screens/auth_gate.dart';
import 'utils/hive_helper_db.dart';
import 'utils/user_data_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.init();
  await HiveHelperDB.init();

  await _initFirebase();
  _setupCrashlytics();

  runApp(MyApp(appTheme: AppTheme()));
}

Future<void> _initFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initializeFirebaseNotifications();
}

void _setupCrashlytics() async {
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
// Add global error catcher for better Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
}

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
    // Get.put(VariableController());
    Get.put(UserDataManager());

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
