import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class NotesController extends GetxController {
  var notesOfList = [].obs;
  final ref = FirebaseFirestore.instance
      .collection('notesNoted')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('nts');

  @override
  void onInit() {
    super.onInit();
    fetchAndSetData();
  }

  void fetchAndSetData() {
    // You can add the fetch data from Hive DB if needed
    // List<NotesModel> tempnoteList = hiveHelperDB.fetchData();
    // notesOfList.addAll(tempnoteList);
  }


  void deleteNote(String noteId) {
    ref.doc(noteId).delete().then((_) {
      Get.snackbar("Deleted", "Note has been deleted successfully");
    }).catchError((error) {
      Get.snackbar("Error", "Failed to delete the note: $error");
    });
  }
}
