import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactService {
  Future<bool> checkPermission() async {
    final status = await Permission.contacts.status;
    if (status.isGranted) {
      return true;
    }

    if (status.isPermanentlyDenied) {
      return false;
    }

    final result = await Permission.contacts.request();
    return result.isGranted;
  }

  Future<Contact?> pickContact() async {
    try {
      if (await checkPermission()) {
        final contact = await FlutterContacts.openExternalPick();
        if (contact != null) {
          final fullContact = await FlutterContacts.getContact(contact.id);
          return fullContact;
        }
      } else {
        throw Exception('Rehber izni verilmedi');
      }
    } catch (e) {
      print('Error in pickContact: $e');
      rethrow;
    }
    return null;
  }

  Future<void> saveContact({
    required String name,
    required String phoneNumber,
    required bool isManualEntry,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('emergency_contact_name', name);
    await prefs.setString('emergency_contact_number', phoneNumber);
    await prefs.setBool('is_manual_entry', isManualEntry);
  }

  Future<Map<String, String?>> getSavedContact() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('emergency_contact_name'),
      'phoneNumber': prefs.getString('emergency_contact_number'),
    };
  }
}
