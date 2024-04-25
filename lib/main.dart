import 'package:firebase_core/firebase_core.dart';
import 'package:s_chat/services/auth_services/auth_services.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:s_chat/screens/auth_screens/auth_gate.dart';
import 'package:s_chat/theme.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDire = await getApplicationDocumentsDirectory();
  // Hive.init(appDocumentDire.path);
  await Hive.initFlutter();
  // Hive.registerAdapter(adapter);
  await Hive.openBox('notesHiveData');

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
      home: const AuthGate(),
      // getPages: AppRoutes.appRoutes(),
    );
  }
}
