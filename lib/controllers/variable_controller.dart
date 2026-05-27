import 'package:get/get.dart';

import '../utils/local_db.dart';

// class VariableController extends GetxController {
//   RxBool isLoading = false.obs;
//
//   RxString uid = ''.obs;
//   RxString email = ''.obs;
//   RxString phoneNumber = ''.obs;
//   RxString userName = ''.obs;
//   RxString photoURL = ''.obs;
//   RxString fcmToken = ''.obs;
//
//   // /// SAVE user info
//   // Future<void> saveUserInfo({
//   //   required String name,
//   //   required String phone,
//   //   required String username,
//   // }) async {
//   //   final prefs = await SharedPreferences.getInstance();
//   //   await prefs.setString('name', name);
//   //   await prefs.setString('phone', phone);
//   //   await prefs.setString('username', username);
//   // }
//   //
//   // /// GET user info
//   // Future<void> getUserInfo() async {
//   //   final prefs = await SharedPreferences.getInstance();
//   //   userName.value = prefs.getString('name') ?? '';
//   //   phoneNumber.value = prefs.getString('phone') ?? '';
//   //   uid.value = prefs.getString('username') ?? '';
//   // }
//
//   @override
//   void onInit() {
//     super.onInit();
//     localDB();
//   }
//
//
//   localDB() async {
//     await LocalDB().getUserEmail().then((value) {
//       email.value = value.toString();
//     });
//
//     await LocalDB().getFcmToken().then((value) {
//       fcmToken.value = value.toString();
//     });
//
//     await LocalDB().getUserEmail().then((value) {
//       userName.value = value.toString();
//     });
//
//     // await LocalDB().getIsMailExist().then((value) {
//     //   isMailExist.value = (value) ?? false;
//     // });
//     // removeLocalDBValueOnLogOut() async {}
// }
//   loadDataForAutoLogIn() async {
//
//     // await LocalDB().getUserEmail().then((value) {
//     //   email.value = (value.toString());
//     // });
//     // await LocalDB().getFcmToken().then((value) {
//     //   fcmTokenString.value = (value.toString());
//     // });
//     // await LocalDB().getUserDeviceId().then((value) {
//     //   userDeviceIdString.value = value.toString();
//     // });
//     // await LocalDB().getUserDeviceName().then((value) {
//     //   userDeviceNameString.value = value.toString();
//     // });
//     // await LocalDB().getUserDeviceOSType().then((value) {
//     //   userDeviceOsTypeString.value = value.toString();
//     // });
//     // await LocalDB().getFcmNotificationUniqueIdList().then((value) {
//     //   fcmNotificationUniqueIdString.value = value ?? [];
//     // });
//   }
// }
