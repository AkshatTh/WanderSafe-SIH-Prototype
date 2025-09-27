import 'package:flutter/material.dart';
import 'package:wandersafe_app/core/widgets/category_button.dart';
import 'package:wandersafe_app/features/onboarding/presentation/screens/create_id_screen.dart';

class CategorySelectionScreen extends StatelessWidget {
  const CategorySelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    void navigateToCreateId() {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const CreateIdScreen()),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: const Alignment(0.0, -0.4),
              child: Image.asset(
                'assets/images/globe_character.png',
                height: screenHeight * 0.5,
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.language, color: Colors.white, size: 20),
                              SizedBox(width: 4),
                              Text('LN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.4),
                    const Text(
                      'WanderSafe',
                      style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white, shadows: [Shadow(blurRadius: 10.0, color: Colors.black38, offset: Offset(2.0, 2.0))]),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Select your category',
                      style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    CategoryButton(
                      text: 'International Tourist',
                      onPressed: navigateToCreateId,
                      backgroundColor: const Color(0xFFC73636),
                    ),
                    const SizedBox(height: 16),
                    CategoryButton(
                      text: 'Domestic Tourist',
                      onPressed: navigateToCreateId,
                      backgroundColor: const Color(0xFF364F6B),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}