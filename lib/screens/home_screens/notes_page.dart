import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s_chat/model/notes_models/noteM.dart';
import 'package:s_chat/res/components/round_Textfield.dart';
import 'package:s_chat/screens/notes_screen/notes_editScreen.dart';
import 'package:s_chat/services/hiveDb/database.dart';

class NotesPage extends StatefulWidget {
  final NotesModel? notesModel;

  const NotesPage({super.key, this.notesModel});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<NotesModel> notesOfList = [];
  final HiveHelperDB hiveHelperDB = HiveHelperDB();
  final ref = FirebaseFirestore.instance
      .collection('notesNoted')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('nts');
  final TextEditingController searchController = TextEditingController();

  void addOrEditNote(NotesModel notesModel) {
    setState(() {
      var existNote = notesOfList.firstWhere(
        (n) => n.title == notesModel.title,
      );
      // orElse: () => NotesModel(id: '', title: '', description: '')); // Avoids null errors
      if (existNote.title.isEmpty) {
        notesOfList.add(notesModel); // Adds new note if not found
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAndSetData();
  }

  void fetchAndSetData() {
    // Uncomment and fetch data if needed from Hive DB
    // List<NotesModel> tempnoteList = hiveHelperDB.fetchData();
    // notesOfList.addAll(tempnoteList);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
        title: const Text(
          'Your Notes',
          style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                NotesModel finalData = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            NotesEditScreen(onSave: addOrEditNote)));
                setState(() => notesOfList.add(finalData));
              },
              icon: const Icon(Icons.add)),
          PopupMenuButton<String>(
            // onSelected: (value) => print(value),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: "View Gride/List",
                child: Text("View"),
              ),
              const PopupMenuItem(
                value: "Sync with Google",
                child: Text("Sync"),
              ),
            ],
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Center(
              child: RoundTextField(
                width: double.infinity,
                controller: searchController,
                hintText: 'search here',
                textbackgroundColor: Colors.white,
                onPressed: () {},
              ),
            ),
            const SizedBox(height: 10),
            Flexible(
              child: StreamBuilder(
                stream: ref.snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
                  if (!snapshots.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshots.data?.docs.length ?? 0,
                    itemBuilder: (_, index) {
                      final notes = snapshots.data?.docs[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(
                            notes?['title'] ?? '',
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            notes?['content'] ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(10)),
                          onTap: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => NotesEditScreen(
                                        onSave: addOrEditNote)));
                          },
                          trailing: IconButton(
                            onPressed: () {
                              Get.dialog(
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Material(
                                            child: Column(
                                              children: [
                                                const SizedBox(height: 10),
                                                const Text(
                                                  "Delete Note",
                                                  textAlign: TextAlign.center,
                                                ),
                                                const SizedBox(height: 15),
                                                const Text(
                                                  "Are you Sure?",
                                                  textAlign: TextAlign.center,
                                                ),
                                                const SizedBox(height: 20),
                                                //Buttons
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          foregroundColor:
                                                              const Color(
                                                                  0xFFFFFFFF),
                                                          backgroundColor:
                                                              Colors.green,
                                                          minimumSize:
                                                              const Size(0, 45),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          Get.back();
                                                          ref
                                                              .doc(notes?.id)
                                                              .delete()
                                                              .then((_) =>
                                                                  Get.snackbar(
                                                                      "Deleted",
                                                                      "Note has been deleted successfully"))
                                                              .catchError((error) =>
                                                                  Get.snackbar(
                                                                      "Error",
                                                                      "Failed to delete the note: $error"));
                                                        },
                                                        child: const Text(
                                                          'YES',
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          foregroundColor:
                                                              const Color(
                                                                  0xFFFFFFFF),
                                                          backgroundColor:
                                                              Colors.green,
                                                          minimumSize:
                                                              const Size(0, 45),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          Get.back();
                                                        },
                                                        child: const Text(
                                                          'NO',
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
