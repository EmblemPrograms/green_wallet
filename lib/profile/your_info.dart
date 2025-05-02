import 'package:flutter/material.dart';
import 'package:green_wallet/widgets/textborder.dart';
import 'package:green_wallet/profile/chatus.dart';

class YourInformationPage extends StatefulWidget {
  const YourInformationPage({Key? key}) : super(key: key);

  @override
  State<YourInformationPage> createState() => _YourInformationPageState();
}

class _YourInformationPageState extends State<YourInformationPage> {
  final TextEditingController _firstNameController = TextEditingController(text: 'Abdul');
  final TextEditingController _lastNameController = TextEditingController(text: 'Gafar');
  final TextEditingController _emailController = TextEditingController(text: 'Abdulgafar@gmail.com');
  final TextEditingController _dateController = TextEditingController();

  String? _selectedGender;

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(1995, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _dateController.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/avatar.png'), // Replace with your image path
            ),
            const SizedBox(height: 10),
            const Text(
              "Abdul Gafar",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const Text("GreenWallet Account", style: TextStyle(color: Colors.grey)),

            const SizedBox(height: 30),

            // First Name
            _buildLabel("First Name"),
            _buildTextField(_firstNameController),

            const SizedBox(height: 16),

            // Last Name
            _buildLabel("Last Name"),
            _buildTextField(_lastNameController),

            const SizedBox(height: 16),

            // Email
            _buildLabel("Email Address"),
            _buildTextField(_emailController),

            const SizedBox(height: 16),

            // Gender & Date of Birth
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
                        builder: (context) =>
                        const ChatScreen()),
                  );// Handle update request
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: Bcolor.enabledBorder,
    );
  }
}
