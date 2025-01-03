import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import '../colors/colors.dart';
import '../services/contact_service.dart';
import '../widgets/emergency_contact_form.dart';
import '../widgets/contact_picker.dart';
import 'home_page.dart';

class EmergencyContactPage extends StatefulWidget {
  const EmergencyContactPage({super.key});

  @override
  State<EmergencyContactPage> createState() => _EmergencyContactPageState();
}

class _EmergencyContactPageState extends State<EmergencyContactPage> {
  final ContactService _contactService = ContactService();
  Contact? _selectedContact;
  String? _selectedPhoneNumber;
  String? _manualName;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  bool _isManualEntry = false;
  String? _savedContactName;
  String? _savedContactPhone;

  @override
  void initState() {
    super.initState();
    _loadSavedContact();
  }

  Future<void> _loadSavedContact() async {
    try {
      final savedContact = await _contactService.getSavedContact();
      print('Saved Contact Data: $savedContact');
      setState(() {
        final name = savedContact['name'];
        final phone = savedContact['phoneNumber'];

        print('Name: $name, Phone: $phone');

        if (name != null && phone != null) {
          _savedContactName = name;
          _savedContactPhone = phone;
        } else {
          _savedContactName = null;
          _savedContactPhone = null;
        }
      });
    } catch (e) {
      print('Error loading saved contact: $e');
      setState(() {
        _savedContactName = null;
        _savedContactPhone = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Acil Durumda Bildirilecek Kişi',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_savedContactName != null) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Kayıtlı Kişi',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _savedContactName!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            _savedContactPhone!,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Yeni Kişi Ekle',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.person_add_outlined,
                            color: Colors.white,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Henüz Kayıtlı Kişi Yok',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Acil durumda ulaşılacak kişiyi eklemek için aşağıdaki seçenekleri kullanabilirsiniz.',
                            style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  _buildEntryTypeToggle(),
                  const SizedBox(height: 30),
                  if (_isManualEntry)
                    EmergencyContactForm(
                      onNameChanged: (value) =>
                          setState(() => _manualName = value),
                      onPhoneChanged: (value) =>
                          setState(() => _selectedPhoneNumber = value),
                      selectedPhoneNumber: _selectedPhoneNumber,
                    )
                  else
                    ContactPicker(
                      selectedContact: _selectedContact,
                      selectedPhoneNumber: _selectedPhoneNumber,
                      onPickContact: _pickContact,
                      onClearContact: () => setState(() {
                        _selectedContact = null;
                        _selectedPhoneNumber = null;
                      }),
                    ),
                  const SizedBox(height: 30),
                  _buildSaveButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickContact() async {
    try {
      final contact = await _contactService.pickContact();
      if (contact != null && contact.phones.isNotEmpty) {
        setState(() {
          _selectedContact = contact;
          _selectedPhoneNumber =
              contact.phones.first.number.replaceAll(RegExp(r'[^\d+]'), '');
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Seçilen kişinin telefon numarası yok'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('Contact picking error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Kişi seçilirken bir hata oluştu: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildEntryTypeToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ChoiceChip(
          label: const Text(
            'Rehberden Seç',
            style: TextStyle(color: AppColors.primaryColor),
          ),
          selected: !_isManualEntry,
          onSelected: (selected) {
            setState(() {
              _isManualEntry = !selected;
              _selectedContact = null;
              _selectedPhoneNumber = null;
            });
          },
          selectedColor: Colors.white,
          labelStyle: TextStyle(
            color: !_isManualEntry ? AppColors.primaryColor : Colors.white,
          ),
        ),
        const SizedBox(width: 10),
        ChoiceChip(
          label: const Text(
            'Manuel Giriş',
            style: TextStyle(color: AppColors.primaryColor),
          ),
          selected: _isManualEntry,
          onSelected: (selected) {
            setState(() {
              _isManualEntry = selected;
              _selectedContact = null;
              _selectedPhoneNumber = null;
            });
          },
          selectedColor: Colors.white,
          labelStyle: TextStyle(
            color: _isManualEntry ? AppColors.primaryColor : Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: (_selectedPhoneNumber != null ||
              (_isManualEntry && _formKey.currentState?.validate() == true))
          ? _saveContact
          : null,
      child: _isLoading
          ? const CircularProgressIndicator()
          : Text(
              'Kaydet',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }

  Future<void> _saveContact() async {
    if (_isManualEntry &&
        (_manualName == null || _selectedPhoneNumber == null)) {
      return;
    }
    if (!_isManualEntry &&
        (_selectedContact == null || _selectedPhoneNumber == null)) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _contactService.saveContact(
        name: _isManualEntry ? _manualName! : _selectedContact!.displayName,
        phoneNumber: _selectedPhoneNumber!,
        isManualEntry: _isManualEntry,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kişi başarıyla kaydedildi')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kişi kaydedilirken bir hata oluştu')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
