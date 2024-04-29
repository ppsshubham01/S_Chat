

import 'package:get/get.dart';

class NoteController extends GetxController{

  // var notes = <NotesModel>[].obs;
  List _notes =[];
  List get notes => _notes;

  setNotes(List data)
  {
    _notes =data;
    update();
  }

  // @override
  // void onInit() {
  //   // TODO: implement onInit
  //   super.onInit();
  //   notes.value = Hive.box('notesHIveData').values.cast<NotesModel>().toList();
  // }
  //
  // void addNotes(NotesModel notesModel){
  //   var box = Hive.box('notesHIveData');
  //   box.add(notesModel);
  //   notes.add(notesModel);
  // }
}