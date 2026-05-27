import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../screens/auth_screens/auth_gate.dart';
import '../screens/home_page/home_page.dart';
import '../services/notification_service.dart';
import '../theme/AppColors.dart';
import '../utils/hive_helper_db.dart';

class GlobalWidgets {


  CameraDescription? firstCamera;

  static parentContainer(
    BuildContext context,
    Widget child,
  ) {
    return SafeArea(
      top: false,
      child: Container(
        height: Get.height,
        width: Get.width,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.white,
              AppColors.blueLight1,
              AppColors.blueLight2
            ],
          ),
        ),
        child: Container(
          height: Get.height,
          width: Get.width,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.white,
          ),
          child: child,
        ),
      ),
    );
  }



  void signOut() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    Get.offAll(const AuthGate());

    await HiveHelperDB.clearUserData();
    await HiveHelperDB.clearBox('settings');


    await NotificationService.unsubscribeNotification();
    await NotificationService.cancelAll();
    // await SharedPreferencesHelper.saveData('uid', firebaseUser.uid);
    // await SharedPreferencesHelper.saveData('email', firebaseUser.email ?? '');
    // await SharedPreferencesHelper.saveData('phoneNumber', firebaseUser.phoneNumber ?? '');
    // await SharedPreferencesHelper.saveData('name', firebaseUser.displayName ?? '');
    // await SharedPreferencesHelper.saveData('photoURL', firebaseUser.photoURL ?? '');
    // await SharedPreferencesHelper.saveData('fcm_token', fcmToken ?? '');

  }


  void updateDropdownValue(String value) {
    // dropdownValue.value = value;
  }

  void navigateToTakePictureScreen() {
    if (firstCamera != null) {
      Get.to(() => TakePictureScreen(camera:firstCamera!));
    } else {
      Get.snackbar('Error', 'Camera is not available',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
