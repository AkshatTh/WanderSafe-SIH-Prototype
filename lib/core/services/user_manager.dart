import 'package:wandersafe_app/features/onboarding/data/models/contact.dart';

class UserManager {
  static final UserManager _instance = UserManager._internal();
  factory UserManager() {
    return _instance;
  }
  UserManager._internal();

  String? username;
  // Add a list to store emergency contacts
  List<Contact> emergencyContacts = [];
}