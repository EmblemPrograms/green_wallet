import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:green_wallet/services/auth_service.dart'; // ✅ Ensure this file exists and has getToken()
import 'package:http/http.dart' as http;
import 'package:green_wallet/widgets/textborder.dart';

class Kin extends StatefulWidget {
  const Kin({super.key});

  @override
  _KinState createState() => _KinState();
}

class _KinState extends State<Kin> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String? _firstName;
  String? _lastName;
  String? _relationship;
  String? _email;
  String? _phone;

  final List<String> _relationshipOptions = [
    'Parent',
    'Sibling',
    'Spouse',
    'Friend',
    'Other',
  ];

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _isLoading = true);

    try {
      final token = await AuthService.getToken();
      if (token == null) {
        _showSnackBar('Authentication error. Please log in again.', isError: true);
        return;
      }

      final url =
          "https://greenwallet-6a1m.onrender.com/api/users/users/next-of-kin?token=$token";

      final body = {
        "first_name": _firstName,
        "last_name": _lastName,
        "relationship": _relationship,
        "email": _email,
        "phone_number": "0${_phone?.trim()}" // ✅ ensures proper formatting
      };

      final response = await http.patch(
        Uri.parse(url),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _showSnackBar(data['message'] ?? 'Next of Kin updated successfully!');
        debugPrint("✅ Response: $data");
      } else {
        debugPrint("❌ Error: ${response.body}");
        _showSnackBar("Failed to update Next of Kin.", isError: true);
      }
    } catch (e) {
      debugPrint("⚠️ Exception: $e");
      _showSnackBar("Something went wrong. Try again later.", isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Next of Kin'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField('First Name', onSaved: (val) => _firstName = val),
              _buildTextField('Last Name', onSaved: (val) => _lastName = val),
              _buildDropdown(),
              _buildTextField('Email Address', onSaved: (val) => _email = val),
              _buildTextField('Phone Number', onSaved: (val) => _phone = val),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF402978),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  'Save Update',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, {required Function(String?) onSaved}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder: Bcolor.enabledBorder,
        ),
        onSaved: onSaved,
        validator: (val) =>
        (val == null || val.isEmpty) ? 'Please enter $label' : null,
      ),
    );
  }

  Widget _buildDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Relationship',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder: Bcolor.enabledBorder,
        ),
        value: _relationship,
        items: _relationshipOptions.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
        onChanged: (val) => setState(() => _relationship = val),
        validator: (val) =>
        (val == null || val.isEmpty) ? 'Please select a relationship' : null,
      ),
    );
  }
}
