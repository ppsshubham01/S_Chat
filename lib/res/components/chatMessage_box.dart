
import 'package:flutter/material.dart';

class ChatMessageBox extends StatelessWidget {
  final String message;
  const ChatMessageBox({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(

      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFFE8E5C3)
      ),
      child: Text(message,style: const TextStyle(fontSize: 16),),

    );
  }
}
