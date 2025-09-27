import 'package:flutter/material.dart';
import 'package:wandersafe_app/features/home/presentation/screens/ai_companion_screen.dart';
import 'package:wandersafe_app/features/home/presentation/screens/crypto_gateway_screen.dart'; // Import the new screen
import 'package:wandersafe_app/features/home/presentation/screens/efir_screen.dart';
import 'package:wandersafe_app/features/home/presentation/screens/live_map_screen.dart';

class FeatureButtonWidget extends StatelessWidget {
  final IconData icon;
  final String label;

  const FeatureButtonWidget({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // --- FINAL NAVIGATION LOGIC ---
            Widget? targetScreen;
            switch (label) {
              case 'Live Map':
                targetScreen = const LiveMapScreen();
                break;
              case 'AI Companion':
                targetScreen = const AiCompanionScreen();
                break;
              case 'E-FIR':
                targetScreen = const EfirScreen();
                break;
              case 'Crypto Gateway':
                targetScreen = const CryptoGatewayScreen();
                break;
            }

            if (targetScreen != null) {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => targetScreen!),
              );
            }
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40, color: const Color(0xFF364F6B)),
                const SizedBox(height: 12),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF364F6B),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
