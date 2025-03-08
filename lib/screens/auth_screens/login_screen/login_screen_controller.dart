import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../widgets/comman.dart';
import '../../home_screens/setting_page/setting_page.dart';

class LoginScreenController extends GetxController {
  // Method to register user with phone number
  Future<void> registerUser(String mobile) async {
    FirebaseAuth auth0 = FirebaseAuth.instance;
    await auth0.verifyPhoneNumber(
      phoneNumber: mobile,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth0.signInWithCredential(credential).then((value) {
          Get.off(() => const SettingPage());
        }).catchError((e) {
          logger.e(" error: $e");
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          // print('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        // Get.to(() => OtpScreen(verificationID: verificationId));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // print("Timeout: $verificationId");
      },
    );
  }
}
