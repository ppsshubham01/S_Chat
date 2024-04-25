import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServicesController extends GetxController {

  Rx<User?> user = Rx<User?>(null);

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
    } catch (e) {
      print('Google signin error $e');
    }
  }

// final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//
// Future<UserCredential> signinWithEmailandPassword(
//     String email, String password) async {
//   try {
//     UserCredential userCredential = await _firebaseAuth
//         .signInWithEmailAndPassword(email: email, password: password);
//     return userCredential;
//   } on FirebaseAuthException catch (e) {
//     throw Exception(e.code);
//   }
// }
}
