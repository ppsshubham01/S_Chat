import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../colors/app_colors.dart';

class RoundTextField extends StatelessWidget {
  const RoundTextField({
    super.key,
    this.height = 70,
    this.width = 160,
    required this.onPressed,
    this.suffixOnPressed,
    this.textColor = AppColor.primaryTextColors,
    this.textbackgroundColor = AppColor.secondaryButtonColors,
    this.cursorColor = AppColor.primaryColors,
    this.hintText = '',
    required this.controller,
    this.keyboardType,
    this.textAlign = TextAlign.start,
    this.textCapitalization = TextCapitalization.none,
    this.obscureText = false,
    this.enabled = true,
    this.maxLength,
    this.maxLines = 1,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.inputFormatters,
    this.autofocus = false,
    this.autovalidateMode = AutovalidateMode.disabled,
  });

  final String hintText;
  final TextEditingController controller;
  final VoidCallback onPressed;
  final VoidCallback? suffixOnPressed;
  final Color textColor, textbackgroundColor, cursorColor;
  final double height, width;
  final TextAlign textAlign;
  final TextCapitalization textCapitalization;
  final bool obscureText;
  final bool enabled;
  final int? maxLength;
  final int maxLines;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final void Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final bool autofocus;
  final AutovalidateMode autovalidateMode;

  @override
  Widget build(BuildContext context) {
    RxString controlllerText = controller.text.obs;


    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: textbackgroundColor,
        ),
        child: Center(
          child: Obx(
            ()=> TextFormField(
              controller: controller,
              decoration: InputDecoration(
                suffixIcon: controlllerText.isNotEmpty  || controller.text.isNotEmpty// This is chatGPT
                    ?GestureDetector(
                    onTap:() {
                      controller.clear(); // Clear text
                      if (suffixOnPressed == null) {
                        suffixOnPressed!(); // Execute suffix onPressed callback if provided
                      }
                    },
                    child: const Icon(Icons.cancel_outlined))
                      :  const SizedBox(),
                hintText: hintText,
                // border: InputBorder.none,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              ),
              style: TextStyle(
                color: textColor,
              ),
              textAlign: textAlign,
              textCapitalization: textCapitalization,
              obscureText: obscureText,
              enabled: enabled,
              maxLength: maxLength,
              maxLines: maxLines,
              validator: validator,
              onSaved: onSaved,
              onChanged: (val){
                controlllerText.value=val;
                if(onChanged !=null){
                  onChanged!(val);
                }
              },
              inputFormatters: inputFormatters,
              autofocus: autofocus,
              autovalidateMode: autovalidateMode,
              keyboardType: keyboardType,
            ),
          ),
        ),
      ),
    );
  }
}
