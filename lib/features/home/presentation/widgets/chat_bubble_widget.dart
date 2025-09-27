import 'package:flutter/material.dart';

class ChatBubbleWidget extends StatelessWidget {
  final String text;
  final bool isFromAI;

  const ChatBubbleWidget({
    super.key,
    required this.text,
    required this.isFromAI,
  });

  @override
  Widget build(BuildContext context) {
    // Align the bubble left for AI, right for the user
    final alignment = isFromAI ? Alignment.centerLeft : Alignment.centerRight;
    // Choose colors based on the sender
    final bubbleColor = isFromAI ? Colors.white : const Color(0xFF364F6B);
    final textColor = isFromAI ? Colors.black87 : Colors.white;
    // Apply different border radius for a classic chat look
    final borderRadius = isFromAI
        ? const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          );

    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: borderRadius,
          boxShadow: [
             if (isFromAI)
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
              )
          ]
        ),
        child: Text(
          text,
          style: TextStyle(color: textColor, fontSize: 16),
        ),
      ),
    );
  }
}