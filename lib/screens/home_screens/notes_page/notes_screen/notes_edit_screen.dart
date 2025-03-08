import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s_chat/services/note_services/notes_services.dart';

import '../../../../services/database_services.dart';


class NotesEditScreen extends StatefulWidget {
  final QueryDocumentSnapshot? note;

  const NotesEditScreen({Key? key, this.note}) : super(key: key);

  @override
  State<NotesEditScreen> createState() => _NotesEditScreenState();
}

class _NotesEditScreenState extends State<NotesEditScreen> {
  late TextEditingController titleController;
  late TextEditingController contentController;
  final NotesServices _notesServices = NotesServices();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note?['title'] ?? '');
    contentController = TextEditingController(text: widget.note?['content'] ?? '');
  }

  void saveNote() {
    if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
      _notesServices.saveNotesToFireStore(
        widget.note?.id ?? '',
        titleController.text,
        contentController.text,
      );
    }
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: TextField(
          controller: titleController,
          decoration: const InputDecoration(border: InputBorder.none, hintText: 'Your Title'),
        ),
        actions: [
          IconButton(onPressed: saveNote, icon: const Icon(Icons.save)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: contentController,
                decoration: const InputDecoration(hintText: "Start Writing here..."),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                expands: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
