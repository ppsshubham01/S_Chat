import 'package:flutter/material.dart';
import 'package:s_chat/model/notes_models/noteM.dart';

class NotesEditScreen extends StatefulWidget {
  final NotesModel? notesModel;
  final Function(NotesModel) onSave;
  NotesEditScreen({super.key, this.notesModel, required this.onSave});

  @override
  State<NotesEditScreen> createState() => _NotesEditScreenState();
}

class _NotesEditScreenState extends State<NotesEditScreen> {
  late TextEditingController titleController = TextEditingController();
  late TextEditingController contentController = TextEditingController();
  DateTime _lastEditText = DateTime.now();



  void _addressControllerListener() {
    print(titleController.text);
  }

  void saveNotes(){
    if(titleController.text.isNotEmpty && contentController.text.isNotEmpty){
      final note = NotesModel(title: titleController.text, content:contentController.text);
      widget.onSave(note);
      Navigator.pop(context);
    }
    setState(() {});
  }
  


  void onTextChange(){
    setState(() {
      _lastEditText = DateTime.now();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    // titleController.addListener(() { _addressControllerListener();});
    super.initState();
    titleController = TextEditingController(text: widget.notesModel?.title ?? '' );
    contentController = TextEditingController(text: widget.notesModel?.content ?? '');
    
    contentController.addListener(onTextChange);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    titleController.removeListener(() {_addressControllerListener(); });
    contentController.removeListener(onTextChange);
    super.dispose();
  }
  //******************************Listener Widget use in that for good User interaction************************************

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double boxWidth = screenWidth * 0.75;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        // backgroundColor: Color(0xFF252525),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AppBar(
            backgroundColor: Colors.green,
            // automaticallyImplyLeading: false,
            // Text(widget.note == null ? 'Add Note' : 'Edit Note'),
            title: SizedBox(
              width: boxWidth,
              child: Center(
                child: TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    // helperText: ,
                      border: InputBorder.none, hintText: 'Your Title'),
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.edit),
                tooltip: 'Edit title Name',
              ),
              IconButton(
                onPressed: saveNotes,
                icon: const Icon(Icons.save),
                tooltip: 'More Option',
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert_outlined),
                tooltip: 'More Option',
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Editing /2 min Ago"),
                  Text(_lastEditText.toString())
                ],
              ),
              const Expanded(
                child: TextField(
                  decoration: InputDecoration(hintText: "Start Writing here...",),
                  scrollPadding: EdgeInsets.all(20.0),
                  keyboardType: TextInputType.multiline,
                  autofocus: true,
                  maxLines: null,
                  minLines: null,
                  expands: true,
                  textCapitalization: TextCapitalization.sentences,
                  cursorColor: Colors.black,
                  // cursorRadius: Radius.circular(16.0),
                  cursorWidth: 8.0,
                ),
              ),


            ],
            // child: ,
          ),
        ),
      ),
    );
  }
}
