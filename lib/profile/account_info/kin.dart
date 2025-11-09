import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:green_wallet/services/auth_service.dart';
import 'package:green_wallet/widgets/textborder.dart';

class Kin extends StatefulWidget {
  const Kin({super.key});

  @override
  _KinState createState() => _KinState();
}

class _KinState extends State<Kin> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isFetching = true;

  // Controllers to prefill data
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _relationship;

  final List<String> _relationshipOptions = [
    'Parent',
    'Sibling',
    'Spouse',
    'Friend',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        _showSnackBar('Authentication error. Please log in again.', isError: true);
        return;
      }

      final url =
          'https://greenwallet-6a1m.onrender.com/api/users/profile?token=$token';
      final response = await http.get(Uri.parse(url), headers: {'accept': 'application/json'});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['next_of_kin'] != null) {
          final kin = data['next_of_kin'];
          setState(() {
            _firstNameController.text = kin['first_name'] ?? '';
            _lastNameController.text = kin['last_name'] ?? '';
            _relationship = kin['relationship'] ?? '';
            _emailController.text = kin['email'] ?? '';
            _phoneController.text = kin['phone_number'] ?? '';
          });
        }
      } else {
        debugPrint("❌ Failed to fetch profile: ${response.body}");
      }
    } catch (e) {
      debugPrint("⚠️ Error fetching profile: $e");
    } finally {
      setState(() => _isFetching = false);
    }
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;

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
        "first_name": _firstNameController.text.trim(),
        "last_name": _lastNameController.text.trim(),
        "relationship": _relationship,
        "email": _emailController.text.trim(),
        "phone_number": _phoneController.text.trim(),
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
      } else {
        debugPrint("❌ Error: ${response.body}");
        _showSnackBar("Failed to update Next of Kin.", isError: true);
      }
    } catch (e) {
      debugPrint("⚠️ Exception: $e");
      _showSnackBar("Something went wrong. Try again later.", isError: true);
    } finally {
      setState(() => _isLoading = false);
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
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
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
      body: _isFetching
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField('First Name', controller: _firstNameController),
              _buildTextField('Last Name', controller: _lastNameController),
              _buildDropdown(),
              _buildTextField('Email Address', controller: _emailController),
              _buildTextField('Phone Number', controller: _phoneController),
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

  Widget _buildTextField(String label, {required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder: Bcolor.enabledBorder,
        ),
        validator: (val) => (val == null || val.isEmpty) ? 'Please enter $label' : null,
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
        value: _relationship != null && _relationship!.isNotEmpty
            ? _relationship
            : null,
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
