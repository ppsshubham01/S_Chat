import 'package:get/get.dart';

class VariableController extends GetxController {
  RxBool isLoading = false.obs;

  RxString uid = ''.obs;
  RxString email = ''.obs;
  RxString phoneNumber = ''.obs;
  RxString userName = ''.obs;
  RxString photoURL = ''.obs;
  RxString fcmToken = ''.obs;
}
