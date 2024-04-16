import 'package:flutter/material.dart';
import '../colors/app_colors.dart';

class RoundTextField extends StatelessWidget {
  const RoundTextField({
    super.key,
    required this.title,
    this.height = 70,
    this.width = 60,
    required this.onPress,
    this.textColor = AppColor.primaryTextColors,
    this.buttonColor = AppColor.primaruButtonColors,
  });

  final String title;
  final double height, width;
  final VoidCallback onPress;
  final Color textColor, buttonColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: buttonColor, borderRadius: BorderRadius.circular(40)),
        child: Center(
            child: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.white),
        )),
      ),
    );
  }
}
