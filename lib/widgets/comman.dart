import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

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


final Logger logger = Logger(printer: PrettyPrinter());

final talker = TalkerFlutter.init(
  logger: TalkerLogger(
    settings: TalkerLoggerSettings(
      colors: {
        LogLevel.debug: AnsiPen()..green(),
        LogLevel.info: AnsiPen()..white(),
        LogLevel.critical: AnsiPen()..red(),
        LogLevel.error: AnsiPen()..magenta(),
        LogLevel.warning: AnsiPen()..yellow(),
        LogLevel.verbose: AnsiPen()..gray(),
      },
      // lineSymbol: '~',
      // maxLineWidth: 70,
    ),
    output: (message) {
      printTalker(message);
    },
  ),
  settings: TalkerSettings(enabled: true),
);

void printTalker(String text) async {
  log(text);
  if (!text.contains("INFO")) {
    // await Sentry.captureMessage(
    //   appIsLive
    //       ? "Live Tenat App - $customerId - $text"
    //       : "Testing Tenant App - $customerId - $text",
    //   level: SentryLevel.info,
    // );
  }
}
