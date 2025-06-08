import 'package:cloud_firestore/cloud_firestore.dart';

class NotesModel {
  String id;
  String title;
  String content;
  Timestamp timestamp;
  String currentUserUID;

  NotesModel({
    required this.id,
    required this.title,
    required this.content,
    required this.timestamp,
    required this.currentUserUID,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'timestamp': timestamp,
      'currentUserUID': currentUserUID,
    };
  }
}
