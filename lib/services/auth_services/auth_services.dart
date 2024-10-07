import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:s_chat/controllers/variable_controller.dart';

class AuthServicesController extends GetxController {
  Rx<User?> user = Rx<User?>(null);
  VariableController variableController = Get.put(VariableController());

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  // Method to sign in with Google
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
      _fireStore.collection('users').doc(userCredential.user?.uid).set({
        'uid': userCredential.user?.uid,
        'email': userCredential.user?.email
      },SetOptions(merge: true));
      variableController.isLoading.value = false;
    } catch (e) {
      print('Google signing error $e');
    }
  }
}
