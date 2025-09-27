import 'package:flutter/material.dart';
import 'package:wandersafe_app/core/services/user_manager.dart';
import 'package:wandersafe_app/features/onboarding/presentation/screens/add_contacts_screen.dart';

// We convert this to a StatefulWidget to handle the text input controllers
class CreateIdScreen extends StatefulWidget {
  const CreateIdScreen({super.key});

  @override
  State<CreateIdScreen> createState() => _CreateIdScreenState();
}

class _CreateIdScreenState extends State<CreateIdScreen> {
  // Create controllers to manage the text fields
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  // Get an instance of our user manager to save the name
  final UserManager _userManager = UserManager();

  @override
  void dispose() {
    // It's important to clean up controllers when the screen is closed
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _verifyAndProceed() {
    // Simple validation to make sure the name isn't empty
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your full name.'), backgroundColor: Colors.red),
      );
      return;
    }

    // --- SAVE THE USERNAME ---
    // This is where we save the name to our central UserManager.
    _userManager.username = _nameController.text.trim();

    // Navigate to the next screen in the onboarding flow
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const AddContactsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('EN', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Create Your\nTourist ID',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 8),
              const Text(
                'Step 1 of 3',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300, width: 1)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_upload_outlined, color: Colors.grey.shade500, size: 40),
                    const SizedBox(height: 8),
                    Text(
                      'Upload your\nidentity proof',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade700, fontWeight: FontWeight.w500)
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              
              // --- THIS IS THE NEW USERNAME FIELD ---
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Enter your full name',
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFE0E0E0))),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF364F6B))),
                ),
                textCapitalization: TextCapitalization.words, // Automatically capitalizes names
              ),
              const SizedBox(height: 20),

              // --- This is the existing phone number field ---
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Enter your mobile number',
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFE0E0E0))),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF364F6B))),
                ),
              ),
              const SizedBox(height: 30),

              // The button now calls our new _verifyAndProceed function
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _verifyAndProceed,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    backgroundColor: const Color(0xFF364F6B),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                  ),
                  child: const Text('Verify', style: TextStyle(fontSize: 18, color: Colors.white))
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}

