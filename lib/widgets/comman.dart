import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCommaDialog(Widget method) {
  showDialog(
    context: Get.context!,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: method,
      );
    },
  );
}

Widget customLoadingIndicator() {
  return Center(
    child: SizedBox(
      height: 60,
      width: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const CircularProgressIndicator(
            color: Colors.greenAccent,
          ),
          globalTextUI(
            textString: "Loading",
            textSize: 18,
            isFontBold: false,
            fontColor: Colors.black,
            isFontUnderline: false,
            numberOfLines: 1,
            textCenter: false,
          ),
        ],
      ),
    ),
  );
}

Widget globalTextUI({
  required String textString,
  required double textSize,
  required bool isFontBold,
  Color fontColor = Colors.black,
  bool isFontUnderline = false,
  bool textCenter = false,
  int numberOfLines = 1,
  FontStyle fontStyle = FontStyle.normal,
}) {
  return Text(
    textString,
    overflow: TextOverflow.ellipsis,
    softWrap: true,
    maxLines: numberOfLines,
    textAlign: textCenter ? TextAlign.center : TextAlign.start,
    style: TextStyle(
      decoration: isFontUnderline ? TextDecoration.underline : TextDecoration.none,
      fontSize: textSize,
      fontWeight: isFontBold ? FontWeight.bold : FontWeight.normal,
      letterSpacing: .2,
      fontStyle: fontStyle,
      color: fontColor,
    ),
  );
}