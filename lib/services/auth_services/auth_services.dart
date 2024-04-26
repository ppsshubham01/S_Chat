import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServicesController extends GetxController {
  Rx<User?> user = Rx<User?>(null);

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  // Method to sign in with Google
  Future<void> signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

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
      print('user name: ${user.value?.displayName}');
      print('user email: ${user.value?.email}');
      _fireStore.collection('users').doc(userCredential.user?.uid).set({
        'uid': userCredential.user?.uid,
        'email': userCredential.user?.email
      },SetOptions(merge: true));
    } catch (e) {
      print('Google signin error $e');
    }
  }
}
