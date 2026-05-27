import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'hive_helper_db.dart';

/// 🔹 This class manages user data across the app.
/// It syncs data between Hive (local) and Firestore (cloud).


class UserDataManager extends GetxController {
  static UserDataManager get to => Get.find<UserDataManager>();

  RxMap<String, dynamic> userData = <String, dynamic>{}.obs;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  /// ✅ Load user data on app start
  Future<void> loadUserOnAppStart() async {
    try {
      var localUser = await HiveHelperDB.getUserData();

      if (localUser != null) {
        userData.value = localUser;
        Get.log('📦 Loaded user from Hive');
      } else {
        Get.log('⚠️ No local user found, fetch from Firestore if required');
      }
    } catch (e) {
      Get.log('❌ loadUserOnAppStart error: $e');
    }
  }

  /// ✅ Save user data both locally and in memory
  Future<void> saveUserData(Map<String, dynamic> data) async {
    try {
      userData.value = data;
      await HiveHelperDB.saveUserData(data);
      Get.log('💾 User data saved to Hive + memory');
    } catch (e) {
      Get.log('❌ saveUserData error: $e');
    }
  }

  /// ✅ Fetch from Firestore manually
  Future<void> fetchUserFromFirestore(String uid) async {
    try {
      var doc = await fireStore.collection('users').doc(uid).get();
      if (doc.exists) {
        var cloudData = doc.data() ?? {};
        await saveUserData(cloudData);
        Get.log('☁️ Synced user from Firestore');
      }
    } catch (e) {
      Get.log('❌ fetchUserFromFirestore error: $e');
    }
  }

  /// ✅ Clear user (logout)
  Future<void> clearUser() async {
    userData.clear();
    await HiveHelperDB.clearUserData();
    Get.log('🚪 User cleared from Hive and memory');
  }
}
