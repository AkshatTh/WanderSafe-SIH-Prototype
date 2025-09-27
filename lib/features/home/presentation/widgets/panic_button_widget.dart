import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wandersafe_app/core/services/user_manager.dart';

class PanicButtonWidget extends StatefulWidget {
  const PanicButtonWidget({super.key});

  @override
  State<PanicButtonWidget> createState() => _PanicButtonWidgetState();
}

class _PanicButtonWidgetState extends State<PanicButtonWidget> {
  final StreamController<double> _progressController = StreamController<double>.broadcast();
  Timer? _holdTimer;
  final int _holdDurationSeconds = 3;

  @override
  void dispose() {
    _progressController.close();
    _holdTimer?.cancel();
    super.dispose();
  }

  void _startHold() {
    _holdTimer?.cancel();
    int elapsedMilliseconds = 0;
    const int intervalMilliseconds = 50;
    _holdTimer = Timer.periodic(const Duration(milliseconds: intervalMilliseconds), (timer) {
      elapsedMilliseconds += intervalMilliseconds;
      double progress = elapsedMilliseconds / (_holdDurationSeconds * 1000);
      _progressController.add(progress);
      if (progress >= 1.0) {
        timer.cancel();
        _triggerSOS();
      }
    });
  }

  void _cancelHold() {
    _holdTimer?.cancel();
    _progressController.add(0.0);
  }

  void _triggerSOS() {
    // --- ACCESS USER AND CONTACT DATA ---
    final username = UserManager().username ?? 'the user';
    final contacts = UserManager().emergencyContacts;
    final contactNames = contacts.isNotEmpty ? contacts.map((c) => c.name).join(', ') : 'your contacts';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('SOS Activated for $username!'),
          // --- UPDATED: Dynamic alert message ---
          content: Text('Authorities and emergency contacts ($contactNames) are being notified of your location.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                _cancelHold();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: StreamBuilder<double>(
        stream: _progressController.stream,
        initialData: 0.0,
        builder: (context, snapshot) {
          final progress = snapshot.data ?? 0.0;
          return GestureDetector(
            onLongPressStart: (_) => _startHold(),
            onLongPressEnd: (_) => _cancelHold(),
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(value: progress, strokeWidth: 8, backgroundColor: Colors.red.shade100, valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFC73636))),
                Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFFFF5F5F), Color(0xFFC73636)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: const Color(0xFFC73636).withOpacity(0.4), spreadRadius: 3, blurRadius: 15, offset: const Offset(0, 8))],
                  ),
                  child: const Center(child: Text('PANIC\nBUTTON', textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white, height: 1.2))),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}