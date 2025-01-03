import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import '../themes/colors.dart';

class ContactPicker extends StatelessWidget {
  final Contact? selectedContact;
  final String? selectedPhoneNumber;
  final VoidCallback onPickContact;
  final VoidCallback onClearContact;

  const ContactPicker({
    super.key,
    this.selectedContact,
    this.selectedPhoneNumber,
    required this.onPickContact,
    required this.onClearContact,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (selectedContact != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.white24,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text(
                selectedContact!.displayName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                selectedPhoneNumber ?? 'Telefon numarası yok',
                style: const TextStyle(color: Colors.white70),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: onClearContact,
              ),
            ),
          ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: onPickContact,
          icon: Icon(Icons.contact_phone, color: AppColors.primaryColor),
          label: Text(
            'Rehberden Seç',
            style: TextStyle(color: AppColors.primaryColor),
          ),
        ),
      ],
    );
  }
}
