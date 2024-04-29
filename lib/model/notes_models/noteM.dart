import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../controllers/note_controlller/notes_controller.dart';
import '../../services/hiveDb/database.dart';

part 'noteM.g.dart';

@HiveType(typeId: 0)
class NotesModel extends HiveObject{


  @HiveField(0)
  int id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  NotesModel({required this.id,required this.title,required this.description, });

  add(){
    final NoteController noteController = Get.find();
    List notes = noteController.notes;
    notes.add(this);
    HiveHelperDB().putNotes(notes);
    // Get.off(() => ViewNoteScreen(note: this));
    Get.snackbar("Add", "Success", snackPosition: SnackPosition.BOTTOM);
  }

  @override
  delete() async {
    final NoteController noteController = Get.put(NoteController());
    List notes = noteController.notes;
    notes.remove(this);
    HiveHelperDB().putNotes(notes);
    Get.snackbar("Delete", "Success", snackPosition: SnackPosition.BOTTOM);
  }

  edit(String title, String description){
    this.title = title;
    this.description = description;
    final NoteController noteController = Get.put(NoteController());
    List notes = noteController.notes;
    notes[id] = this;
    HiveHelperDB().putNotes(notes);
    // Get.off(() => ViewNoteScreen(note: this));
    Get.snackbar("Edit", "Success", snackPosition: SnackPosition.BOTTOM);
  }

// }
//
// @HiveType(typeId: 1)
// class HiveNotesModel {
//   @HiveField(0)
//   String id;
//
//   @HiveField(1)
//   String title;
//
//   @HiveField(2)
//   String content;
//
//   HiveNotesModel({required this.id,required this.title, required this.content});
}
