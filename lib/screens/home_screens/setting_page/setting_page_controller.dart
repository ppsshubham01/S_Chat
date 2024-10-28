
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../auth_screens/auth_gate/auth_gate.dart';

class SettingPageController extends GetxController {
  var user = FirebaseAuth.instance.currentUser.obs;
  var dropdownValue = ''.obs;

  void signOut() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    Get.offAll(const AuthGate());
  }

  void updateDropdownValue(String value) {
    dropdownValue.value = value;
  }
}
