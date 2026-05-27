import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../utils/sharedpref_helper.dart';
import '../../utils/hive_helper_db.dart';
import '../../utils/local_db.dart';
import '../../utils/user_data_manager.dart';

class AuthGateController extends GetxController {
  Rx<User?> user = Rx<User?>(null);
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  static AuthGateController get instance => Get.find();

  var verificationId = ''.obs;

  Stream<User?> get authStateChanges => auth.authStateChanges();

  @override
  void onInit() {
    super.onInit();
    UserDataManager.to.loadUserOnAppStart();
  }

  // 🔹 ---------- COMMON SUCCESS LOGIN HANDLER ----------
  Future<void> handleSuccessfulLogin(User? firebaseUser) async {
    if (firebaseUser == null) return;

    user.value = firebaseUser;
    String? fcmToken = await FirebaseMessaging.instance.getToken();

    try {
      /// 1️⃣ Check if user exists in Firestore
      bool exists = await checkUserExists(firebaseUser.uid);

      /// 2️⃣ Fetch existing Firestore data if exists
      Map<String, dynamic>? firestoreData;
      if (exists) {
        firestoreData = await getUserFromFirestore(firebaseUser.uid);
      }

      /// 3️⃣ Prepare Google login data
      Map<String, dynamic> googleData = {
        'uid': firebaseUser.uid,
        'email': firebaseUser.email ?? '',
        'phoneNumber': firebaseUser.phoneNumber ?? '',
        'name': firebaseUser.displayName ?? '',
        'photoURL': firebaseUser.photoURL ?? '',
        'fcm_token': fcmToken ?? '',
        'lastUpdated': DateTime.now(),
        'createdAt': exists && firestoreData != null
            ? firestoreData['createdAt'] ?? DateTime.now()
            : DateTime.now(),
      };

      /// 4️⃣ Compare Firestore data vs Google login
      Map<String, dynamic> finalData =
          Map.from(googleData); // default Google data

      if (firestoreData != null) {
        // Compare timestamps and pick the latest for each field
        finalData['email'] = (firebaseUser.email != null &&
                firebaseUser.email != firestoreData['email'])
            ? firebaseUser.email
            : firestoreData['email'];

        finalData['phoneNumber'] = (firebaseUser.phoneNumber != null &&
                firebaseUser.phoneNumber != firestoreData['phoneNumber'])
            ? firebaseUser.phoneNumber
            : firestoreData['phoneNumber'];

        finalData['name'] = (firebaseUser.displayName != null &&
                firebaseUser.displayName != firestoreData['name'])
            ? firebaseUser.displayName
            : firestoreData['name'];

        finalData['photoURL'] = (firebaseUser.photoURL != null &&
                firebaseUser.photoURL != firestoreData['photoURL'])
            ? firebaseUser.photoURL
            : firestoreData['photoURL'];

        // FCM token always update
        finalData['fcm_token'] = fcmToken ?? firestoreData['fcm_token'];

        // lastUpdated = now
        finalData['lastUpdated'] = DateTime.now();

        // Keep original createdAt
        finalData['createdAt'] =
            firestoreData['createdAt'] ?? googleData['createdAt'];
      }

      /// 5️⃣ Save finalData to Firestore (create or update)
      await saveOrUpdateUserFirestore(firebaseUser.uid, finalData);

      /// 6️⃣ Save finalData to HiveDB
      await HiveHelperDB.saveUserData(finalData);

      /// 7️⃣ Sync to UserDataManager for UI
      await UserDataManager.to.saveUserData(finalData);

      /// 8️⃣ Optional SharedPreferences
      await SharedPreferencesHelper.saveData('uid', finalData['uid']);
      await SharedPreferencesHelper.saveData('email', finalData['email'] ?? '');
      await SharedPreferencesHelper.saveData(
          'phoneNumber', finalData['phoneNumber'] ?? '');
      await SharedPreferencesHelper.saveData('name', finalData['name'] ?? '');
      await SharedPreferencesHelper.saveData(
          'photoURL', finalData['photoURL'] ?? '');
      await SharedPreferencesHelper.saveData(
          'fcm_token', finalData['fcm_token'] ?? '');

      /// 9️⃣ LocalDB (custom)
      LocalDB().saveUserEmail(finalData['email'] ?? '');
      LocalDB().saveFcmToken(finalData['fcm_token']);
      LocalDB().saveUserFullName(finalData['name']);

      Get.log('✅ handleSuccessfulLogin: data synced Firestore + Hive + Local');
    } catch (e) {
      Get.snackbar("Firestore Sync Error", e.toString());
    }
  }

  /// 🔹 Sync latest data between Google Login and Firestore
  Future<Map<String, dynamic>> syncUserData(User firebaseUser) async {
    // 1️⃣ Get Firestore user (if exists)
    var firestoreData = await getUserFromFirestore(firebaseUser.uid);

    // 2️⃣ Prepare Google user data
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    Map<String, dynamic> googleData = {
      'uid': firebaseUser.uid,
      'email': firebaseUser.email ?? '',
      'phoneNumber': firebaseUser.phoneNumber ?? '',
      'name': firebaseUser.displayName ?? '',
      'photoURL': firebaseUser.photoURL ?? '',
      'fcm_token': fcmToken ?? '',
      'lastUpdated': DateTime.now(),
      'createdAt': firestoreData?['createdAt'] ?? DateTime.now(),
    };

    // 3️⃣ Decide which data is latest
    Map<String, dynamic> latestData = {};

    if (firestoreData != null) {
      DateTime firestoreTime = firestoreData['lastUpdated'] is Timestamp
          ? (firestoreData['lastUpdated'] as Timestamp).toDate()
          : firestoreData['lastUpdated'] ?? DateTime(2000);

      DateTime googleTime = googleData['lastUpdated'];

      // If Firestore has latest changes, keep it
      if (firestoreTime.isAfter(googleTime)) {
        latestData = {...firestoreData};
        latestData['fcm_token'] = fcmToken ?? firestoreData['fcm_token'];
      } else {
        latestData = {...googleData};
      }
    } else {
      // No Firestore data → use Google data
      latestData = {...googleData};
    }

    // 4️⃣ Save to Firestore (merge)
    await saveOrUpdateUserFirestore(firebaseUser.uid, latestData);

    // 5️⃣ Save to HiveDB
    await HiveHelperDB.saveUserData(latestData);

    // 6️⃣ Update UserDataManager memory
    await UserDataManager.to.saveUserData(latestData);

    return latestData;
  }

  // 🔹 ---------- FIRESTORE HELPERS ----------
  Future<bool> checkUserExists(String uid) async {
    try {
      var doc = await fireStore.collection('users').doc(uid).get();
      return doc.exists;
    } catch (e) {
      Get.log('checkUserExists error: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> getUserFromFirestore(String uid) async {
    try {
      var doc = await fireStore.collection('users').doc(uid).get();
      if (doc.exists) return doc.data();
      return null;
    } catch (e) {
      Get.log('getUserFromFirestore error: $e');
      return null;
    }
  }

  Future<void> saveOrUpdateUserFirestore(
      String uid, Map<String, dynamic> userData) async {
    try {
      await fireStore
          .collection('users')
          .doc(uid)
          .set(userData, SetOptions(merge: true));
      Get.log('✅ Firestore: user data saved/updated');
    } catch (e) {
      Get.log('saveOrUpdateUserFirestore error: $e');
    }
  }

  Future<void> deleteUserFirestore(String uid) async {
    try {
      await fireStore.collection('users').doc(uid).delete();
      Get.log('🗑️ User deleted from Firestore');
    } catch (e) {
      Get.log('deleteUserFirestore error: $e');
    }
  }

  // 🔹 ---------- GOOGLE SIGN-IN ----------
  Future<void> signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await auth.signInWithCredential(credential);
      await handleSuccessfulLogin(userCredential.user);
    } catch (e) {
      Get.snackbar("Google Login Error", e.toString());
    }
  }
}
