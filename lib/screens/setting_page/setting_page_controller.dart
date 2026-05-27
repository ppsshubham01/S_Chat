
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../services/notification_service.dart';
import '../../utils/user_data_manager.dart';
import '../auth_screens/auth_gate.dart';


class SettingPageController extends GetxController {
  static SettingPageController get to => Get.find();

  /// Reactive user data from Hive / UserDataManager
  RxMap<String, dynamic> userData = <String, dynamic>{}.obs;

  RxString dropdownValue = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUser();
  }

  /// Load user data from Hive (or Firestore if needed)
  Future<void> loadUser() async {
    var localUser = await UserDataManager.to.loadUserOnAppStart();
    userData.value = UserDataManager.to.userData.value;
  }

  /// Update dropdown value
  void updateDropdownValue(String value) {
    dropdownValue.value = value;
  }

  /// Sign out logic
  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    await NotificationService.unsubscribeNotification();
    await NotificationService.cancelAll();
    await UserDataManager.to.clearUser(); // clear Hive + memory
    Get.offAll(() => const AuthGate());
  }

  /// Update user name
  Future<void> updateUserName(String newName) async {
    userData['name'] = newName;
    userData['lastUpdated'] = DateTime.now();
    await UserDataManager.to.saveUserData(userData);
    await UserDataManager.to.saveUserData(userData); // update Hive
    // optionally update Firestore if needed
  }

  /// Update user photo URL
  Future<void> updateUserPhoto(String newPhotoUrl) async {
    userData['photoURL'] = newPhotoUrl;
    userData['lastUpdated'] = DateTime.now();
    await UserDataManager.to.saveUserData(userData);
    // optionally update Firestore if needed
  }
}
