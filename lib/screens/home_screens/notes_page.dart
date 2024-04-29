import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s_chat/model/notes_models/noteM.dart';
import 'package:s_chat/res/components/round_Textfield.dart';
import 'package:s_chat/screens/notes_screen/notes_editScreen.dart';
import 'package:s_chat/services/hiveDb/database.dart';

class NotesPage extends StatefulWidget {
  final NotesModel? notesModel;
  const NotesPage({super.key,this.notesModel});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<NotesModel> notesOfList = [
    // NotesModel(title: "oh achha essa", content: 'Welcome to S-Chat'),
    // NotesModel(title: "Hello There", content: 'Achha laga apse dubara mil kr'),
  ];

  HiveHelperDB hiveHelperDB = HiveHelperDB();

  // NotesModel notesModelss = NotesModel(title: 'title', content: 'content');
  final TextEditingController searchController = TextEditingController();

  void addOrEditNote(NotesModel notesModel) {
    setState(() {
      var existNote = notesOfList.firstWhere(
        (n) => n.title == notesModel.title,
        // orElse: null,
      );
      print("existNote: $existNote");
      if (existNote != null) {
        // existNote.content = notesModel.content;
      } else {
        notesOfList.add(notesModel);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAndSetData();
  }

  void fetchAndSetData() {
    // List<NotesModel> tempnoteList = hiveHelperDB.fetchData();
    // notesOfList.addAll(tempnoteList);
    // setState(() {});
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
              onPressed: () async {
                // // Get.toNamed(RouteName.notesEditScreen); question for routes in passing arguments
                // NotesModel dinalD =Get.to(() => NotesEditScreen(onSave: addOrEditNote)) as NotesModel;
                NotesModel finalData = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => NotesEditScreen(
                            // notesModel: notesModelss,
                            onSave: addOrEditNote)));
                print("dknsdknvjknvjksdnvjdksn : ${finalData.title}");
                setState(() {
                  // notesModelss = finalData;
                  notesOfList.add(finalData);
                });
              },
              icon: const Icon(Icons.add)),
          PopupMenuButton<String>(
            onSelected: (value) {
              print(value);
            },
            itemBuilder: (BuildContext contesxt) {
              return [
                const PopupMenuItem(
                  value: "View Gride/List",
                  child: Text("View"),
                ),
                const PopupMenuItem(
                  value: "Sync with Google",
                  child: Text("Sync"),
                ),
              ];
            },
          )
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
            // GetBuilder(builder: (NoteController noteController){
            //   return noteController.notes.length == 0 ? const Center(
            //     child: Text("No data found !"),
            //   ): ListView.builder(
            //       itemCount: noteController.notes.length,
            //       itemBuilder: (context, index){
            //         return NoteView(note: noteController.notes[index]);
            //       }
            //   );
            // }),
            Flexible(
              child: ListView.builder(
                  itemCount: notesOfList.length,
                  itemBuilder: (context, index) {
                    final note = notesOfList[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(
                          notesOfList[index].title,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          // notesOfList[index].content.split('\n').first,
                          // overflow: TextOverflow.ellipsis,
                          ""
                        ),
                        shape: RoundedRectangleBorder(
                            side:
                                const BorderSide(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        onTap: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => NotesEditScreen(
                                      notesModel: note,
                                      onSave: addOrEditNote)));
                        },
                        trailing: IconButton(
                            onPressed: () {
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text(
                                    'Delete?',
                                    style: TextStyle(color: Colors.redAccent),
                                  ),
                                  content: const Text(
                                      'sure you want to delete this note!'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancel'),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Get.defaultDialog(
                                          title: "Delete this Note ?",
                                          middleText: "",
                                          textConfirm: "Delete",
                                          textCancel: "Cancel",
                                          cancelTextColor: Colors.pinkAccent,
                                          confirmTextColor: Colors.black,
                                          onConfirm: (){
                                            widget.notesModel?.delete();
                                            Get.back();
                                          },
                                        );
                                      },
                                      child: const Text(
                                        'YES',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            )),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
