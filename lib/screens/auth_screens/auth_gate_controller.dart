import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:s_chat/controllers/variable_controller.dart';
import 'package:s_chat/screens/auth_screens/otp_screen.dart';

import '../../../utils/sharedpref_helper.dart';
import '../../services/notification_service.dart';
import '../../utils/local_db.dart';
import '../home_screens.dart';

class AuthGateController extends GetxController {
  Rx<User?> user = Rx<User?>(null);
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final VariableController variableController = Get.put(VariableController());

  static AuthGateController get instance => Get.find();

  var verificationId = ''.obs;

  Stream<User?> get authStateChanges => auth.authStateChanges();

  // ---------- PHONE AUTH ----------

  void sendOTP(String phoneNumber) async {
    variableController.isLoading.value = true;


    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
        handleSuccessfulLogin(auth.currentUser);
      },
      verificationFailed: (FirebaseAuthException e) {
        variableController.isLoading.value = false;

        Get.snackbar("Verification Failed", e.message ?? "Try again");
      },
      codeSent: (String verId, int? resendToken) {
        verificationId.value = verId;
        variableController.isLoading.value = false;
        Get.to(() => OTPScreen());
      },
      codeAutoRetrievalTimeout: (String verId) {
        verificationId.value = verId;
      },
    );
  }

  void verifyOTP(String otpCode) async {
    try {
      variableController.isLoading.value = true;

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: otpCode,
      );

      UserCredential result = await auth.signInWithCredential(credential);
      handleSuccessfulLogin(result.user);

      variableController.isLoading.value = false;
      Get.offAll(() => const HomeScreen());
    } catch (e) {
      variableController.isLoading.value = false;
      Get.snackbar("Invalid OTP", "Please check the OTP and try again.");
    }
  }

  // ---------- COMMON SUCCESS LOGIN HANDLER ----------
  Future<void> handleSuccessfulLogin(User? firebaseUser) async {
    if (firebaseUser == null) return;

    user.value = firebaseUser;

    String? fcmToken = await FirebaseMessaging.instance.getToken();
    // await NotificationService.subscribeNotification();



    variableController.uid.value = firebaseUser.uid;
    // variableController.email.value = firebaseUser.email ?? '';
    variableController.phoneNumber.value = firebaseUser.phoneNumber ?? '';
    // variableController.userName.value = firebaseUser.displayName ?? '';
    variableController.photoURL.value = firebaseUser.photoURL ?? '';
    variableController.fcmToken.value = fcmToken ?? '';

    // Save to Firestore
    await fireStore.collection('users').doc(firebaseUser.uid).set({
      'uid': firebaseUser.uid,
      'email': firebaseUser.email ?? '',
      'phoneNumber': firebaseUser.phoneNumber ?? '',
      'name': firebaseUser.displayName ?? '',
      'photoURL': firebaseUser.photoURL ?? '',
      'fcm_token': fcmToken ?? '',
      'createdAt': DateTime.now(),
    }, SetOptions(merge: true));

    // Save to SharedPreferences
    await SharedPreferencesHelper.saveData('uid', firebaseUser.uid);
    await SharedPreferencesHelper.saveData('email', firebaseUser.email ?? '');
    await SharedPreferencesHelper.saveData('phoneNumber', firebaseUser.phoneNumber ?? '');
    await SharedPreferencesHelper.saveData('name', firebaseUser.displayName ?? '');
    await SharedPreferencesHelper.saveData('photoURL', firebaseUser.photoURL ?? '');
    await SharedPreferencesHelper.saveData('fcm_token', fcmToken ?? '');



    // custom localD
    LocalDB().saveUserEmail(variableController.email.value);
    LocalDB().saveFcmToken(fcmToken);
    LocalDB().saveUserFullName(firebaseUser.displayName);
  }

  // ---------- GOOGLE LOGIN (UNCHANGED) ----------
  Future<void> signInWithGoogle() async {
    try {
      variableController.isLoading.value = true;

      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential = await auth.signInWithCredential(credential);
      handleSuccessfulLogin(userCredential.user);

      variableController.isLoading.value = false;
    } catch (e) {
      variableController.isLoading.value = false;
      Get.snackbar("Google Login Error", e.toString());
    }
  }
}

