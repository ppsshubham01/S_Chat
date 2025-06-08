
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../services/notification_service.dart';
import '../auth_screens/auth_gate.dart';


class SettingPageController extends GetxController {
  var user = FirebaseAuth.instance.currentUser.obs;
  var dropdownValue = ''.obs;

  void signOut() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    Get.offAll(const AuthGate());

    await NotificationService.unsubscribeNotification();
    await NotificationService.cancelAll();
    // await SharedPreferencesHelper.saveData('uid', firebaseUser.uid);
    // await SharedPreferencesHelper.saveData('email', firebaseUser.email ?? '');
    // await SharedPreferencesHelper.saveData('phoneNumber', firebaseUser.phoneNumber ?? '');
    // await SharedPreferencesHelper.saveData('name', firebaseUser.displayName ?? '');
    // await SharedPreferencesHelper.saveData('photoURL', firebaseUser.photoURL ?? '');
    // await SharedPreferencesHelper.saveData('fcm_token', fcmToken ?? '');

  }

  void updateDropdownValue(String value) {
    dropdownValue.value = value;
  }
}
