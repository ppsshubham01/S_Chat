import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:s_chat/controllers/note_controlller/notes_controller.dart';

class HiveHelperDB {
  final _myBox = Hive.box('noteBox');

  getNotes() {
    //This method return all the notes stored in our database;
    return Hive.box('noteBox').get("notes", defaultValue: []);
  }

  putNotes(List data) async {
    //This method take a List as parameters and set it in our database with "notes" as key.
    // After that, we call setNotes() of our NoteController which take notes return by
    // our getNotes() as parameters.
    final NoteController noteController = Get.find();
    await Hive.box("noteBox").put('notes', data);
    List notes = getNotes();
    noteController.setNotes(notes);
  }

  // void writeData(
  //   String id,
  //   String title,
  //   String content,
  // ) {
  //   _myBox.put(id, title);
  // }
  //
  // List<NotesModel> fetchData() {
  //   List<NotesModel>? fetchData = _myBox.values
  //       .cast<NotesModel>()
  //       .toList(); //------------------as cast check-------
  //   return fetchData;
  // }
  //
  // void deleteData(String id) {
  //   _myBox.delete(id);
  // }
  //
  // void deleteAllData() {
  //   _myBox.clear();
  // }
  //
  // void updateData() {}
}
