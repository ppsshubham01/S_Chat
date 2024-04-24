
import 'package:hive/hive.dart';
import 'package:s_chat/model/notes_models/noteM.dart';

class HiveHelperDB {
  final _myBox = Hive.box('notesHiveData');

  void writeData(
    String id,
    String title,
    String content,
  ) {
    _myBox.put(id, title);
  }

  List<NotesModel> fetchData() {
    List<NotesModel>? fetchData = _myBox.values.cast<NotesModel>().toList();//------------------as cast check-------
    return fetchData;
  }

  void deleteData(String id) {
    _myBox.delete(id);
  }

  void deleteAllData() {
    _myBox.clear();
  }

  void updateData() {}
}
