import 'dart:io';
import 'package:flutter/material.dart';
import 'package:green_wallet/Card/hompage.dart';
import 'package:image_picker/image_picker.dart';

class IDVerify extends StatefulWidget {
  const IDVerify({super.key});

  @override
  State<IDVerify> createState() => _IDVerifyState();
}

class _IDVerifyState extends State<IDVerify> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _bvnController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  String _selectedGender = "Male";
  String? _selectedDocumentType;
  File? _frontImage;
  File? _backImage;

  final picker = ImagePicker();

  final List<String> _documentTypes = [
    "National ID",
    "Voter’s Card",
    "Driver’s License",
    "International Passport",
  ];

  Future<void> _pickImage(bool isFront) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (isFront) {
          _frontImage = File(pickedFile.path);
        } else {
          _backImage = File(pickedFile.path);
        }
      });
    }
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    final Map<String, dynamic> payload = {
      "bvn": _bvnController.text.trim(),
      "document_type": _selectedDocumentType,
      "front": _frontImage?.path,
      "back": _backImage?.path,
      "date_of_birth": _dateController.text.trim().isEmpty
          ? null
          : _dateController.text.trim(),
      "gender": _selectedGender,
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✅ BVN Data Ready: ${payload.toString()}")),
    );

    // TODO: Proceed to next page or make API call
    // Example navigation:
     Navigator.push(context, MaterialPageRoute(builder: (_) => const hompage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Verify User's Identity",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // BVN Input Section
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "BVN",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _bvnController,
                  decoration: InputDecoration(
                    hintText: "Enter your BVN",
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    counterText: "",
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 11,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "BVN is required";
                    } else if (value.length != 11) {
                      return "BVN must be 11 digits";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Document Type
                DropdownButtonFormField<String>(
                  value: _selectedDocumentType,
                  decoration: InputDecoration(
                    labelText: "Document Type",
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: _documentTypes
                      .map((String type) => DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  ))
                      .toList(),
                  onChanged: (value) => setState(() {
                    _selectedDocumentType = value;
                  }),
                  validator: (value) =>
                  value == null ? "Select a document type" : null,
                ),

                const SizedBox(height: 20),

                // Front Image Picker
                _buildImagePicker(
                  label: "Front Document *",
                  file: _frontImage,
                  onTap: () => _pickImage(true),
                ),
                const SizedBox(height: 20),

                // Back Image Picker
                _buildImagePicker(
                  label: "Back Document (Optional)",
                  file: _backImage,
                  onTap: () => _pickImage(false),
                ),
                const SizedBox(height: 20),

                // Date of Birth
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Date of Birth",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "Select date of birth",
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
                  ),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode()); // Prevent keyboard
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2000),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: Color(0xFF442266), // Purple accent color
                              onPrimary: Colors.white,
                              onSurface: Colors.black,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );

                    if (pickedDate != null) {
                      setState(() {
                        _dateController.text =
                        "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                      });
                    }
                  },
                ),


                const SizedBox(height: 20),

                // Gender Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Gender",
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: ['Male', 'Female']
                      .map((gender) => DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender),
                  ))
                      .toList(),
                ),

                const SizedBox(height: 30),

                // Submit Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF442266), // Dark purple
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: _submitForm,
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker({
    required String label,
    required File? file,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: file == null
                ? const Center(
              child: Text(
                "No file chosen",
                style: TextStyle(color: Colors.grey),
              ),
            )
                : ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                file,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
