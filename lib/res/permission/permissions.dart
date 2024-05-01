import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandling extends StatelessWidget {
  const PermissionHandling({super.key});

  /// Permission Handling
  Future<void> requestPermission() async {
    Map<Permission, PermissionStatus> permissionStatus = await [
      Permission.camera,
      Permission.photos,
      Permission.videos,
      Permission.storage,
      Permission.location,
      Permission.microphone,
    ].request();

    if (permissionStatus[Permission.storage]!.isGranted &&
        permissionStatus[Permission.camera]!.isGranted) {
      getFromGallery();
    } else {
      print('no permission provided');
      Get.defaultDialog(
        title: "no permission provided",
        middleText: "no permission provided!,Please Provide",
        backgroundColor: Colors.black38,
        titleStyle: const TextStyle(color: Colors.white),
        middleTextStyle: const TextStyle(color: Colors.white),
      );
    }

    if (permissionStatus[Permission.camera]!.isDenied) {}
    if (permissionStatus[Permission.photos]!.isDenied) {}
    if (permissionStatus[Permission.videos]!.isDenied) {}
    if (permissionStatus[Permission.storage]!.isDenied) {}
    if (permissionStatus[Permission.location]!.isDenied) {}
    if (permissionStatus[Permission.microphone]!.isDenied) {}
  }

  Future<bool> checkPermanentlyDenied() async {
    final permission = Permission.camera;

    return await permission.status.isPermanentlyDenied;
  }

  void openSettings() {
    openAppSettings();
  }

  getFromGallery() async {
    try {
      XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
      );
      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
      }
    } catch (e) {
      var status = await Permission.photos.status;
      if (status.isDenied) {
        if (kDebugMode) {
          print('Access Denied');
          // showAlertDialog(context);
        }
      } else {
        if (kDebugMode) {
          print('Exception occurred!');
        }
      }
    }
  }

  showAlertDialog(context) => showCupertinoDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('Permission Denied'),
          content: const Text('Allow access to gallery and photos'),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => openAppSettings(),
              child: const Text('Settings'),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(),
      ),
    );
  }
}

// class Permission {}
