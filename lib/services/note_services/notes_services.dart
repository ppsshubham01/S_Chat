import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class NotesServices extends GetxController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  saveNotesToFireStore(String? id, String title, String content) async {
    String currentUserID = _firebaseAuth.currentUser!.uid.toString();
    final Timestamp timestamp = Timestamp.now();
    String ids = currentUserID;

    // NotesModel notesModel = NotesModel(id: id, title: title, description: description)

    await _firestore.collection('notesNoted').doc(ids).collection('nts').add({
      'id': id,
      'title': title,
      'content': content,
      'timestamp': timestamp,
      'currentUserUID': currentUserID,
    });
    // .whenComplete(() => Get.back());
  }
}
