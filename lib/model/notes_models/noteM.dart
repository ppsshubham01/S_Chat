import 'package:hive/hive.dart';

class NotesModel {
  String title;
  String content;

  NotesModel({required this.title, required this.content});
}

@HiveType(typeId: 1)
class HiveNotesModel {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String content;

  HiveNotesModel({required this.id,required this.title, required this.content});
}
