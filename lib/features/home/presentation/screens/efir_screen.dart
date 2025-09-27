import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting
import 'package:wandersafe_app/core/services/user_manager.dart';

class EfirScreen extends StatelessWidget {
  const EfirScreen({super.key});

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 100, child: Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade600))),
          const SizedBox(width: 16),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final username = UserManager().username ?? 'N/A';
    final contacts = UserManager().emergencyContacts;

    // --- GET & FORMAT THE CURRENT TIME ---
    final currentTime = DateTime.now();
    // Format: 1:42 AM, 27 Sep 2025
    final formattedTime = DateFormat('h:mm a, d MMM yyyy').format(currentTime);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('File an E-FIR', style: TextStyle(color: Colors.black)), backgroundColor: Colors.white, elevation: 1, iconTheme: const IconThemeData(color: Colors.black)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Incident Details', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Your personal and location details have been pre-filled from your Digital ID and the time of the incident.', style: TextStyle(color: Colors.grey, fontSize: 15)),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(color: const Color(0xFFF0F4F8), borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _buildInfoRow('Name', username),
                  const Divider(),
                  _buildInfoRow('Digital ID', 'WSAFE-8A3B-C9D1-7E2F'),
                  const Divider(),
                  _buildInfoRow('Location', 'Necklace Road, Hyderabad'),
                  const Divider(),
                  // --- UPDATED: Use the formatted live time ---
                  _buildInfoRow('Time', formattedTime),
                ],
              ),
            ),
            const SizedBox(height: 30),
            
            const Text('Registered Emergency Contacts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(color: Colors.blue.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: contacts.map((contact) => _buildInfoRow(contact.relationship, '${contact.name} (${contact.phone})')).toList(),
              ),
            ),
            const SizedBox(height: 30),

            const TextField(maxLines: 8, decoration: InputDecoration(hintText: 'Please describe the incident in detail...', alignLabelWithHint: true, labelText: 'Incident Description', border: OutlineInputBorder(), enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFE0E0E0))), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF364F6B))))),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  showDialog(context: context, builder: (ctx) => AlertDialog(title: const Text("E-FIR Submitted"), content: const Text("Your report has been sent to the relevant authorities. You will receive updates shortly."), actions: <Widget>[TextButton(onPressed: () { Navigator.of(ctx).pop(); Navigator.of(context).pop(); }, child: const Text("Okay"))]));
                },
                icon: const Icon(Icons.send_outlined, color: Colors.white),
                label: const Text('Submit to Authorities', style: TextStyle(color: Colors.white, fontSize: 18)),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 18), backgroundColor: const Color(0xFF364F6B), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}