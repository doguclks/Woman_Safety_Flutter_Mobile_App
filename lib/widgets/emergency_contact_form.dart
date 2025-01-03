import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../colors/colors.dart';

class EmergencyContactForm extends StatelessWidget {
  final Function(String) onNameChanged;
  final Function(String) onPhoneChanged;
  final String? selectedPhoneNumber;

  const EmergencyContactForm({
    super.key,
    required this.onNameChanged,
    required this.onPhoneChanged,
    this.selectedPhoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          TextFormField(
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'İsim',
              labelStyle: TextStyle(color: Colors.white70),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white54),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Lütfen bir isim girin';
              }
              return null;
            },
            onChanged: onNameChanged,
          ),
          const SizedBox(height: 20),
          IntlPhoneField(
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Telefon Numarası',
              labelStyle: TextStyle(color: Colors.white70),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white54),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            dropdownTextStyle: const TextStyle(color: Colors.white),
            initialCountryCode: 'TR',
            onChanged: (phone) => onPhoneChanged(phone.completeNumber),
          ),
        ],
      ),
    );
  }
}
