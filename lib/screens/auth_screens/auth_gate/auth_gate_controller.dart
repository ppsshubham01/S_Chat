import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // Import Firebase Messaging
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:s_chat/controllers/variable_controller.dart';

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

      // Sign in with Firebase
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Update user data in the controller
      user.value = userCredential.user;

      // Store user data in Firestore
      _fireStore.collection('users').doc(userCredential.user?.uid).set({
        'uid': userCredential.user?.uid,
        'email': userCredential.user?.email,
        // Add more fields as necessary
      }, SetOptions(merge: true));

      // Get FCM token and store it in Firestore
      await _storeFCMToken(userCredential.user!.uid);

      variableController.isLoading.value = false;
    } catch (e) {
      logger.e("Google signIn error: $e");
    }
  }

  // Method to store the FCM token in Firestore
  Future<void> _storeFCMToken(String userId) async {
    try {
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) {
        await _fireStore.collection('users').doc(userId).set({
          'fcm_token': fcmToken,
        }, SetOptions(merge: true)); // Merge to avoid overwriting existing dat
        logger.i("FCM token stored: $fcmToken");
      }
    } catch (e) {
      logger.i("'Error storing FCM token: $e");
    }
  }
}
