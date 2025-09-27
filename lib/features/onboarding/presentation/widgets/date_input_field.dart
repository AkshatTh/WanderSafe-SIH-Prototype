import 'package:flutter/material.dart';

// A reusable widget for the date input fields to keep the code clean.
class DateInputField extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const DateInputField({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF364F6B)),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Placeholder for date text
              Text('Select Date', style: TextStyle(color: Colors.grey)),
              Icon(Icons.calendar_today_outlined, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}