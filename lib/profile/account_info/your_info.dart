import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:green_wallet/widgets/textborder.dart';


import '../../services/auth_service.dart';
import 'chatus.dart';


class YourInformationPage extends StatefulWidget {
  const YourInformationPage({super.key});

  @override
  State<YourInformationPage> createState() => _YourInformationPageState();
}

class _YourInformationPageState extends State<YourInformationPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  Uint8List? _selfieBytes;
  String? _selfieUrl;
  String? _selectedGender;
  String _fullName = "Loading..."; // Default value

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadSelfie();
  }

  Future<void> _loadSelfie() async {
    final profile = await AuthService.getUserProfile();

    final selfieValue = profile["selfie"];
    if (selfieValue != null && selfieValue.isNotEmpty) {
      if (selfieValue.startsWith("http")) {
        setState(() => _selfieUrl = selfieValue);
      } else {
        try {
          setState(() => _selfieBytes = base64Decode(selfieValue));
        } catch (e) {
          debugPrint("Error decoding selfie: $e");
        }
      }
    }
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _fullName = prefs.getString("full_name") ?? "User Name";
      _fullNameController.text = prefs.getString("full_name") ?? "";
      _emailController.text = prefs.getString("email") ?? "";
    });
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(1995, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _dateController.text =
        "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 👇 Build dynamic avatar widget
    Widget avatarWidget;
    if (_selfieBytes != null) {
      avatarWidget = CircleAvatar(
        radius: 40,
        backgroundImage: MemoryImage(_selfieBytes!),
      );
    } else if (_selfieUrl != null) {
      avatarWidget = CircleAvatar(
        radius: 40,
        backgroundImage: NetworkImage(_selfieUrl!),
      );
    } else {
      avatarWidget = const CircleAvatar(
        radius: 40,
        backgroundImage: AssetImage("assets/photo.png"),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon:
          const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Your Information",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF9F9FB),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 👇 Header section with dynamic avatar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 30, bottom: 20),
              decoration: const BoxDecoration(
              ),
              child: Column(
                children: [
                  avatarWidget,
                  const SizedBox(height: 8),
                  Text(
                    _fullName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Text(
                    "GreenWallet Account",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),

            // 👇 Form section
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Full Name"),
                  _buildTextField(_fullNameController),
                  const SizedBox(height: 16),

                  _buildLabel("Email Address"),
                  _buildTextField(_emailController),
                  const SizedBox(height: 16),

                  // Gender & Date of Birth row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel("Gender"),
                            DropdownButtonFormField<String>(
                              value: _selectedGender,
                              hint: const Text("Select"),
                              items: ['Male', 'Female', 'Other']
                                  .map((gender) => DropdownMenuItem(
                                value: gender,
                                child: Text(gender),
                              ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedGender = value;
                                });
                              },
                              decoration: _inputDecoration(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel("Date of Birth"),
                            TextFormField(
                              controller: _dateController,
                              readOnly: true,
                              onTap: _pickDate,
                              decoration: _inputDecoration().copyWith(
                                hintText: "Select",
                                suffixIcon: const Icon(Icons.calendar_today),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Request Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ChatScreen()),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF3F2771)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        "Request for Update",
                        style: TextStyle(
                          color: Color(0xFF3F2771),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
    );
  }

  Widget _buildTextField(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: _inputDecoration(),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: Bcolor.enabledBorder,
    );
  }
}
