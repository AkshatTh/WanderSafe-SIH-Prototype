import 'package:flutter/material.dart';
import 'package:wandersafe_app/core/services/user_manager.dart';
import 'package:wandersafe_app/features/onboarding/data/models/contact.dart';
import 'package:wandersafe_app/features/onboarding/presentation/screens/trip_details_screen.dart';
import 'package:wandersafe_app/features/onboarding/presentation/widgets/contact_input_field.dart';

// Convert to StatefulWidget to manage controllers and the list of contacts
class AddContactsScreen extends StatefulWidget {
  const AddContactsScreen({super.key});

  @override
  State<AddContactsScreen> createState() => _AddContactsScreenState();
}

class _AddContactsScreenState extends State<AddContactsScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _relationshipController = TextEditingController();

  void _addContactAndProceed() {
    // Basic validation
    if (_nameController.text.trim().isEmpty || _phoneController.text.trim().isEmpty || _relationshipController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one complete emergency contact.'), backgroundColor: Colors.red),
      );
      return;
    }

    // Save the contact to our UserManager
    final newContact = Contact(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      relationship: _relationshipController.text.trim(),
    );
    UserManager().emergencyContacts.add(newContact);

    // Navigate to the next screen
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const TripDetailsScreen()),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _relationshipController.dispose();
    super.dispose();
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text('Add Emergency\nContacts', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Step 2 of 3 (Required)', style: TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 40),

            // Use our custom widget with the controllers
            ContactInputField(label: 'Name', controller: _nameController),
            const SizedBox(height: 20),
            ContactInputField(label: 'Phone Number', controller: _phoneController, inputType: TextInputType.phone),
            const SizedBox(height: 20),
            ContactInputField(label: 'Relationship', controller: _relationshipController),
            const SizedBox(height: 30),
            
            // Note: "Add Another Contact" is a future feature. For the prototype, we enforce one.
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addContactAndProceed, // Use the new function with validation
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  backgroundColor: const Color(0xFF364F6B),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Continue', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}