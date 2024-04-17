import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s_chat/res/components/round_Textfield.dart';
import 'package:s_chat/res/components/round_button.dart';
import 'package:s_chat/res/routes/routes_name.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final TextEditingController searchController = TextEditingController();

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
                Get.toNamed(RouteName.notesEditScreen);
              },
              icon: Icon(Icons.add)),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
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
          ],
        ),
      ),
    );
  }
}
