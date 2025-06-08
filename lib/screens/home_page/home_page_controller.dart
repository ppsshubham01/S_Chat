
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:s_chat/widget/comman.dart';

class HomeController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  var isDark = false.obs;
  CameraController? _controller;
  CameraDescription? firstCamera;

  @override
  void onInit() {
    super.onInit();
    initializePage();
  }

  Future<void> initializePage() async {
    await userConversation();
    await initCamera();
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      firstCamera = cameras.first;
      _controller = CameraController(
        firstCamera!,
        ResolutionPreset.high,
      );

      try {
        await _controller!.initialize();
      } catch (e) {
        logger.e("Camera initialization error: $e");
      }
    }
  }

  Future<void> userConversation() async {
    var conversation = _fireStore.collection('chat_room').doc();
    if (conversation.id.isNotEmpty) {
      // Do something with the conversation.
    }
  }

  void toggleTheme() {
    isDark.value = !isDark.value;
  }

  // This method can be used in TakePictureScreen to access the controller
  CameraController? get cameraController => _controller;

  // Dispose of the controller when no longer needed
  @override
  void onClose() {
    _controller?.dispose();
    super.onClose();
  }
}
