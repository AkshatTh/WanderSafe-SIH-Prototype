import 'package:flutter/material.dart';
import 'package:wandersafe_app/features/home/presentation/screens/home_screen.dart';
import 'package:wandersafe_app/features/onboarding/presentation/widgets/date_input_field.dart';

class TripDetailsScreen extends StatelessWidget {
  const TripDetailsScreen({super.key});

  Future<void> _selectDate(BuildContext context) async {
    await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2024), lastDate: DateTime(2030));
  }

  @override
  Widget build(BuildContext context) {
    void navigateToHome() {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const HomeScreen()), (Route<dynamic> route) => false);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text('Your Trip Details', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Step 3 of 3', style: TextStyle(fontSize: 18, color: Colors.grey)),
                const SizedBox(width: 8),
                // --- ADDED "Optional" CAPTION ---
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(6)),
                  child: const Text('Optional', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                )
              ],
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                DateInputField(label: 'Start Date', onTap: () => _selectDate(context)),
                const SizedBox(width: 16),
                DateInputField(label: 'End Date', onTap: () => _selectDate(context)),
              ],
            ),
            const SizedBox(height: 24),
            const TextField(decoration: InputDecoration(labelText: 'Destination', border: OutlineInputBorder(), enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFE0E0E0))), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF364F6B))))),
            const SizedBox(height: 24),
            Container(padding: const EdgeInsets.all(16.0), decoration: BoxDecoration(color: const Color(0xFFF0F4F8), borderRadius: BorderRadius.circular(12)), child: const Row(children: [Icon(Icons.sync_alt, color: Color(0xFF364F6B)), SizedBox(width: 12), Expanded(child: Text("Sync data from other apps\nto avoid manual typing", style: TextStyle(color: Color(0xFF364F6B))))])),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: navigateToHome,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 18), backgroundColor: const Color(0xFF364F6B), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text('Generate Digital Tourist ID', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
