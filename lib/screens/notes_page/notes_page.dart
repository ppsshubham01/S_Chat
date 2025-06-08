import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../res/components/round_text_form_field.dart';
import '../../services/database_services.dart';
import 'edit_notes_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final List notesOfList = [];
  final ref = FirebaseFirestore.instance
      .collection('notesNoted')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('nts');

  final TextEditingController searchController = TextEditingController();
  final DatabaseService databaseService = DatabaseService.instance;

  @override
  void initState() {
    super.initState();
    fetchAndSetData();
    databaseService.getNotesData();
  }

  void fetchAndSetData() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.green,
          title: const Text(
            'Your Notes',
            style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                var finalData = await Get.to(() => const NotesEditScreen());
                if (finalData != null) {
                  setState(() => notesOfList.add(finalData));
                }
              },
              icon: const Icon(Icons.add),
            ),
            PopupMenuButton<String>(  
              itemBuilder: (context) => [
                const PopupMenuItem(value: "View Gride/List", child: Text("View")),
                const PopupMenuItem(value: "Sync with Google", child: Text("Sync")),
              ],
            )
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: RoundTextField(
                width: double.infinity,
                controller: searchController,
                hintText: 'Search here',
                textbackgroundColor: Colors.transparent,
                onPressed: () {},
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: StreamBuilder(
                stream: ref.snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
                  if (!snapshots.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: snapshots.data?.docs.length ?? 0,
                    itemBuilder: (_, index) {
                      final notesIndex = snapshots.data?.docs[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(
                            notesIndex?['title'] ?? '',
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            notesIndex?['content'] ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          onTap: () {
                            Get.to(() => NotesEditScreen(note: notesIndex));
                          },
                          trailing: IconButton(
                            onPressed: () => _showDeleteDialog(context, notesIndex),
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

  void _showDeleteDialog(BuildContext context, QueryDocumentSnapshot? note) {
    Get.dialog(
      AlertDialog(
        title: const Text("Delete Note"),
        content: const Text("Are you sure you want to delete this note?"),
        actions: [
          TextButton(
            onPressed: () {
              ref.doc(note?.id).delete();
              Get.back();
            },
            child: const Text("YES"),
          ),
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("NO"),
          ),
        ],
      ),
    );
  }
}
