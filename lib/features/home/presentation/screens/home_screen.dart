import 'dart:math';
import 'package:flutter/material.dart';
import 'package:wandersafe_app/core/services/user_manager.dart';
import 'package:wandersafe_app/features/home/presentation/widgets/feature_button_widget.dart';
import 'package:wandersafe_app/features/home/presentation/widgets/panic_button_widget.dart';
import 'package:wandersafe_app/features/home/presentation/widgets/safety_score_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentScore = 93;
  final Random _random = Random();

  void _updateScore() {
    setState(() {
      _currentScore = _random.nextInt(101); // Generates a random number from 0 to 100
    });
  }

  @override
  Widget build(BuildContext context) {
    final username = UserManager().username?.split(' ')[0] ?? 'Wanderer';

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/background.jpg'), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi $username,',
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white, shadows: [Shadow(blurRadius: 5.0, color: Colors.black45, offset: Offset(1.0, 1.0))]),
                        ),
                        const Text(
                          'Safe Travels',
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w300, color: Colors.white, shadows: [Shadow(blurRadius: 5.0, color: Colors.black45, offset: Offset(1.0, 1.0))]),
                        ),
                      ],
                    ),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 5)]), child: const Text('LN', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(child: SafetyScoreWidget(score: _currentScore)),
                    const SizedBox(width: 20),
                    const Expanded(child: PanicButtonWidget()),
                  ],
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    children: const [
                      FeatureButtonWidget(icon: Icons.map_outlined, label: 'Live Map'),
                      FeatureButtonWidget(icon: Icons.support_agent, label: 'AI Companion'),
                      FeatureButtonWidget(icon: Icons.description_outlined, label: 'E-FIR'),
                      FeatureButtonWidget(icon: Icons.currency_bitcoin, label: 'Crypto Gateway'),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _updateScore,
        label: const Text('New Score'),
        icon: const Icon(Icons.refresh),
        backgroundColor: const Color(0xFF364F6B),
      ),
    );
  }
}