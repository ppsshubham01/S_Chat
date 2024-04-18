import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s_chat/controllers/note_controlller/notes_controller.dart';
import 'package:s_chat/model/notes_models/noteM.dart';
import 'package:s_chat/res/components/round_Textfield.dart';
import 'package:s_chat/screens/notes_screen/notes_editScreen.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<NotesModel> notesOfList = [];

  final TextEditingController searchController = TextEditingController();
  final NoteController noteController = Get.put(NoteController());

  void addOrEditNote(NotesModel notesModel) {
    setState(() {
      var existNote = notesOfList.firstWhere(
        (n) => n.title == notesModel.title,
      );
      if (existNote != null) {
        existNote.content = notesModel.content;
      } else {
        notesOfList.add(notesModel);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
        // title: const Text('Your Notes'),
        title: RichText(
          text: const TextSpan(
            text: 'Your',
            style: TextStyle(color: Colors.black38, fontSize: 20),
            children: <TextSpan>[
              TextSpan(
                  text: ' ', style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(
                  text: 'Notes',
                  style: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                // Get.toNamed(RouteName.notesEditScreen); question for routes in passing arguments
                Get.to(() => NotesEditScreen(onSave: addOrEditNote));
              },
              icon: const Icon(Icons.add)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Center(
              child: RoundTextField(
                width: double.infinity,
                onPressed: () {},
                controller: searchController,
                hintText: 'search here',
                // keyboardType: TextInputType.number,
                textbackgroundColor: Colors.white,
                suffixOnPressed: () {
                  // searchController.clear();
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
             Flexible(
                child: ListView.builder(
                    itemCount: notesOfList.length,
                    // itemCount: noteController.notes.length,
                    itemBuilder: (context, index) {
                      final note = notesOfList[index];
                      return ListTile(
                        title: Text(note.title),
                        // title: Text(noteController.notes[index].title),
                        subtitle: Text(note.content.split('\n').first),
                        // subtitle: Text(noteController.notes[index].content.split('\n').first),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      NotesEditScreen(onSave: addOrEditNote)));
                        },
                      );
                    }),
              ),
          ],
        ),
      ),
    );
  }
}
