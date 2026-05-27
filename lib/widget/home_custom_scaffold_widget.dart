import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class HomeCustomScaffoldWidget extends StatelessWidget {
  List<Widget>? actions;
  bool? isBack;
  PreferredSizeWidget? bottom;
  Widget? title;
  Widget? body;
  Widget? floatingActionButton;
  bool? centerTitle;
  Widget? bottomNavigationBar;
  bool? keyValue;
  bool? avoidResize;

  HomeCustomScaffoldWidget(
      {super.key,
      this.actions,
      this.isBack,
      this.title,
      this.body,
      this.bottom,
      this.centerTitle,
      this.bottomNavigationBar,
      this.floatingActionButton,
      this.keyValue,
      this.avoidResize = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: avoidResize,
      bottomNavigationBar: bottomNavigationBar,
      appBar: AppBar(
        centerTitle: centerTitle == true ? true : false,
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: title!,
        bottom: bottom,
        leading: isBack == true
            ? IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(
                  Platform.isIOS
                      ? Icons.arrow_back_ios_new_rounded
                      : Icons.arrow_back,
                  color: Get.theme.dividerColor,
                ))
            :null,
        actions: actions,
      ),
      floatingActionButton: floatingActionButton,
      body: body,
    );
  }
}
