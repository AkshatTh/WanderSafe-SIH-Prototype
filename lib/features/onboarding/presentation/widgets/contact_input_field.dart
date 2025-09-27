import 'package:flutter/material.dart';

class ContactInputField extends StatelessWidget {
  final String label;
  final TextInputType inputType;
  final TextEditingController controller; // Add controller

  const ContactInputField({
    super.key,
    required this.label,
    required this.controller,
    this.inputType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller, // Use the passed controller
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFE0E0E0))),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF364F6B))),
      ),
    );
  }
}
