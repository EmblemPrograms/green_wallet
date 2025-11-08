import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:green_wallet/widgets/textborder.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:green_wallet/widgets/Dialog.dart';

import '../services/auth_service.dart';
import 'Startup.dart';

class Setup extends StatefulWidget {
  const Setup({super.key});

  @override
  State<Setup> createState() => _SetupState();
}

class _SetupState extends State<Setup> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _homeAddressController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  String? _selectedCountry;
  String? _selectedGender;
  String? _selectedOccupation;
  bool _isLoading = false;
  final globalKey = GlobalKey<FormState>();
  File? _selectedFile;
  String? fileName; // Variable to hold the file name
  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        setState(() {
          _selectedFile = File(result.files.single.path!);
          fileName = result.files.single.name;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("📄 File selected: $fileName")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ No file selected. ")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ File selection error ")),
      );
    }
  }

  Future<void> updateProfile() async {
    if (!globalKey.currentState!.validate()) {
      return; // Stop if form is not valid
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 🟩 Try to get token from AuthService first
      String? token = await AuthService.getToken();

      // 🟨 If AuthService didn’t return a token, fall back to SharedPreferences
      if (token == null) {
        final prefs = await SharedPreferences.getInstance();
        token = prefs.getString("auth_token");
      }

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Authentication error. ")),
        );
        return;
      }

      final String apiUrl =
          "https://greenwallet-6a1m.onrender.com/api/users/users/profile/update?token=$token";

      var request = http.MultipartRequest("PUT", Uri.parse(apiUrl));

      // ✅ Add text fields
      request.fields['home_address'] = _homeAddressController.text;
      request.fields['country'] = _selectedCountry ?? "";
      request.fields['state'] = _stateController.text;
      request.fields['city'] = _cityController.text;
      request.fields['date_of_birth'] = _dateController.text;
      request.fields['gender'] = _selectedGender ?? "";
      request.fields['occupation'] = _selectedOccupation ?? "";

      // ✅ Add file if selected
      if (_selectedFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'utility_bill',
            _selectedFile!.path,
          ),
        );
      }

      // ✅ Send request
      var response = await request.send();

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final data = jsonDecode(respStr);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(data['message'] ?? "Profile updated successfully!")),
        );

        await _fetchUserProfile(token);

        // Show loading dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF3F2771),
                ),
              ),
            );
          },
        );

        // Simulate loading delay
        await Future.delayed(const Duration(seconds: 2));
        Navigator.of(context).pop(); // Close loading dialog

        // Show success custom dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => CustomDialogWidget(),
        );
      } else {
        final respStr = await response.stream.bytesToString();
        print("❌ Server Error: ${response.statusCode}");
        print("❌ Response Body: $respStr");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${response.statusCode}, $respStr")),
        );
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print("❌ Network Error: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Network error, try again!")),
      );
    }
  }

  Future<void> _fetchUserProfile(String token) async {
    final String apiUrl =
        "https://greenwallet-6a1m.onrender.com/api/users/profile?token=$token";

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {"Accept": "application/json"},
      );



      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String fullName = data['full_name'] ?? "User";

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("full_name", fullName);
      } else {
        print("❌ Failed to fetch user profile: ${response.body}");
      }
    } catch (error) {
      print("❌ Error fetching user profile: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30,
              height: 4,
              decoration: BoxDecoration(
                color: Bcolor.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: 5),
            Container(
              width: 30,
              height: 4,
              decoration: BoxDecoration(
                color: Bcolor.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: 5),
            Container(
              width: 30,
              height: 4,
              decoration: BoxDecoration(
                color: Bcolor.indicatorcolor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.headphones),
            onPressed: () {
              // Add support functionality here
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: globalKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Text(
                  "Finish your Account Setup",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Home Address",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _homeAddressController,
                  validator: filltextbox,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: 'Enter your current home address',
                    enabledBorder: Bcolor.enabledBorder,
                  ),
                ),
                SizedBox(height: 10),
                const Text(
                  "Country",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                GestureDetector(
                  onTap: () {
                    showCountryPicker(
                      context: context,
                      showPhoneCode: false, // Only show country names
                      onSelect: (Country country) {
                        setState(() {
                          _selectedCountry = country.name;
                        });
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFE0E0E0)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedCountry ?? "Select your country",
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
                        const Icon(Icons.arrow_drop_down, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "State",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _stateController,
                  validator: filltextbox,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: 'Enter State',
                    enabledBorder: Bcolor.enabledBorder,
                  ),
                ),
                SizedBox(height: 10),
                const Text(
                  "City",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _cityController,
                  validator: filltextbox,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: 'Enter city',
                    enabledBorder: Bcolor.enabledBorder,
                  ),
                ),
                SizedBox(height: 10),
                const Text(
                  'Upload Utility Bill',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                GestureDetector(
                  onTap: pickFile, // Calls function when tapped
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFE0E0E0)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(fileName ?? "Select a file to upload"),
                        const Text(
                          "Upload",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF3F2771), // Adjust color as needed
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const SizedBox(width: 10),
                const Text(
                  "Date of Birth",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller:
                      _dateController, // Bind the controller to the field
                  readOnly: true, // Prevent manual text input
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a date of birth';
                    }
                    return null;
                  },
                  onTap: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (selectedDate != null) {
                      _dateController.text = "${selectedDate.toLocal()}"
                          .split(' ')[0]; // Format the selected date
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: 'Select your date of birth',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  "Gender",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                DropdownButtonFormField<String>(
                  value: _selectedGender, // Replace with your variable
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                  validator: filltextbox,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: Bcolor.enabledBorder,
                  ),
                  hint: const Text('Select Gender'),
                  items: ['Male', 'Female', 'Other']
                      .map((gender) => DropdownMenuItem<String>(
                            value: gender,
                            child: Text(gender),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Occupation",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                DropdownButtonFormField<String>(
                  value: _selectedOccupation, // Replace with your variable
                  onChanged: (value) {
                    setState(() {
                      _selectedOccupation = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? "Select occupation" : null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: Bcolor.enabledBorder,
                  ),
                  hint: const Text('Select Occupation'),
                  items: ['Student', 'Employee', 'Entrepreneur', 'Doctor']
                      .map((occupation) => DropdownMenuItem<String>(
                            value: occupation,
                            child: Text(occupation),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _isLoading ? null : updateProfile,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: _isLoading
                        ? Colors.grey
                        : const Color(0xFF3F2771), // Changes color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Next",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String? filltextbox(String? text) {
  if (text == null || text.trim().isEmpty) {
    return 'Field cannot be empty';
  }
  return null;
}
