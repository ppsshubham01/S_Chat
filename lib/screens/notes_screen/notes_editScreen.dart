import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:s_chat/res/components/round_Textfield.dart';

class NotesEditScreen extends StatefulWidget {
  const NotesEditScreen({super.key});

  @override
  State<NotesEditScreen> createState() => _NotesEditScreenState();
}

class _NotesEditScreenState extends State<NotesEditScreen> {
  final TextEditingController titileTextController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    titileTextController.addListener(() { _addressControllerListener();});
    super.initState();
  }
  void _addressControllerListener() {
    print(titileTextController.text);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    titileTextController.removeListener(() {_addressControllerListener(); });
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
            // title: RoundTextField(onPressed: (){}, controller: titileTextController),
            title: SizedBox(
              width: boxWidth,
              child: Center(
                child: TextField(
                  controller: titileTextController,
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
                  Text(DateTime.now().toString())
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
