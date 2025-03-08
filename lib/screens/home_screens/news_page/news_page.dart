import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s_chat/screens/home_screens/news_page/news_page_controller.dart';

class NewsPage extends GetView<NewsPageController> {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Two ListViews in Column"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 500,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(8),
              color: Colors.blue.shade50,
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text("${index + 1}"),
                    ),
                    title: Text("Item ${index + 1} from List 1"),
                  );
                },
              ),
            ),
            Container(
              height: 500,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(8),
              color: Colors.green.shade50,
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text("${index + 1}"),
                    ),
                    title: Text("Item ${index + 1} from List 2"),
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