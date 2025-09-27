import 'package:flutter/material.dart';
import 'package:wandersafe_app/features/onboarding/presentation/screens/category_selection_screen.dart';

void main() {
  runApp(const WanderSafeApp());
}

class WanderSafeApp extends StatelessWidget {
  const WanderSafeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WanderSafe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color(0xFF364F6B),
      ),
      debugShowCheckedModeBanner: false, // Hides the debug banner
      home: const CategorySelectionScreen(),
    );
  }
}

