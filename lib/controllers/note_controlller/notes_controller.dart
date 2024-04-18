

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:s_chat/model/notes_models/noteM.dart';

class NoteController extends GetxController{

  var notes = <NotesModel>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    notes.value = Hive.box('notesHIveData').values.cast<NotesModel>().toList();
  }

  void addNotes(NotesModel notesModel){
    var box = Hive.box('notesHIveData');
    box.add(notesModel);
    notes.add(notesModel);
  }
}