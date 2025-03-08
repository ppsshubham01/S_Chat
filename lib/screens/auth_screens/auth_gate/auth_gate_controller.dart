import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // Import Firebase Messaging
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:s_chat/controllers/variable_controller.dart';

import '../../../utils/sharedpref_helper.dart';
import '../../../widgets/comman.dart';

class AuthGateController extends GetxController {
  Rx<User?> user = Rx<User?>(null);
  VariableController variableController = Get.put(VariableController());
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  // Stream for authentication state changes
  Stream<User?> get authStateChanges =>
      FirebaseAuth.instance.authStateChanges();

  Future<void> signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      variableController.isLoading.value = true;
      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      user.value = userCredential.user;
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      variableController.uid.value = userCredential.user?.uid ?? '';
      variableController.email.value = userCredential.user?.email ?? '';
      variableController.phoneNumber.value =
          userCredential.user?.phoneNumber ?? '';
      variableController.userName.value =
          userCredential.user?.displayName ?? '';
      variableController.photoURL.value = userCredential.user?.photoURL ?? '';
      variableController.fcmToken.value = fcmToken ?? '';

      _fireStore.collection('users').doc(userCredential.user?.uid).set({
        'uid': userCredential.user?.uid,
        'email': userCredential.user?.email,
        'phoneNumber': userCredential.user?.phoneNumber,
        'name': userCredential.user?.displayName,
        'photoURL': userCredential.user?.photoURL,
        'fcm_token': fcmToken,
      }, SetOptions(merge: true));

      await SharedPreferencesHelper.saveData(
          'uid', userCredential.user?.uid ?? '');
      await SharedPreferencesHelper.saveData(
          'email', userCredential.user?.email ?? '');
      await SharedPreferencesHelper.saveData(
          'phoneNumber', userCredential.user?.phoneNumber ?? '');
      await SharedPreferencesHelper.saveData(
          'name', userCredential.user?.displayName ?? '');
      await SharedPreferencesHelper.saveData(
          'photoURL', userCredential.user?.photoURL ?? '');
      await SharedPreferencesHelper.saveData('fcm_token', fcmToken ?? '');

      // Get FCM token and store it in Firestore
      // await _storeFCMToken(userCredential.user!.uid);

      variableController.isLoading.value = false;
    } catch (e) {
      logger.e("Google signIn error: $e");
    }
  }

// Method to store the FCM token in Firestore
// Future<void> _storeFCMToken(String userId) async {
//   try {
//     String? fcmToken = await FirebaseMessaging.instance.getToken();
//     if (fcmToken != null) {
//       await _fireStore.collection('users').doc(userId).set({
//         'fcm_token': fcmToken,
//       }, SetOptions(merge: true)); // Merge to avoid overwriting existing dat
//       logger.i("FCM token stored: $fcmToken");
//     }
//   } catch (e) {
//     logger.i("'Error storing FCM token: $e");
//   }
// }
}
