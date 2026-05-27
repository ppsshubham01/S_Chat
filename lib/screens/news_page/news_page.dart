import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s_chat/widget/global_widget.dart';

import 'news_page_controller.dart';

class NewsPage extends GetView<NewsPageController> {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalWidgets.parentContainer(
        context,
        Container(
          color: Colors.red,
        ));
  }
}
