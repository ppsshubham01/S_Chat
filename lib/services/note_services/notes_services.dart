import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class EditNotedPageController extends GetxController {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;


  saveNotesToFireStore(String? id, String title, String content) async {
    String currentUserID = firebaseAuth.currentUser!.uid;
    final Timestamp timestamp = Timestamp.now();

    final notesCollection = firestore
        .collection('notesNoted')
        .doc(currentUserID)
        .collection('nts');

    if (id != null && id.isNotEmpty) {
      // 🔁 Update existing note
      await notesCollection.doc(id).update({
        'title': title,
        'content': content,
        'timestamp': timestamp,
        'currentUserUID': currentUserID,
      });
    } else {
      // 🆕 Create new note
      DocumentReference newDocRef = notesCollection.doc(); // auto ID
      await newDocRef.set({
        'id': newDocRef.id,
        'title': title,
        'content': content,
        'timestamp': timestamp,
        'currentUserUID': currentUserID,
      });
    }
  }

}
