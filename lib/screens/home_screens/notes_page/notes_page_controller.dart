import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../model/notes_models/note_.dart';

class NotesController extends GetxController {
  var notesOfList = <NotesModel>[].obs;
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

  void addOrEditNote(NotesModel notesModel) {
    var existNote = notesOfList.firstWhere(
          (n) => n.title == notesModel.title,
      // orElse: () => NotesModel(id: '', title: '', description: ''), // Avoids null errors
    );
    if (existNote.title.isEmpty) {
      notesOfList.add(notesModel); // Adds new note if not found
    }
  }

  void deleteNote(String noteId) {
    ref.doc(noteId).delete().then((_) {
      Get.snackbar("Deleted", "Note has been deleted successfully");
    }).catchError((error) {
      Get.snackbar("Error", "Failed to delete the note: $error");
    });
  }
}
