import 'package:flutter/material.dart';
import 'package:green_wallet/widgets/textborder.dart';
import 'chatus.dart';


class YourAddressPage extends StatefulWidget {
  const YourAddressPage({super.key});

  @override
  State<YourAddressPage> createState() => _YourAddressPageState();
}

class _YourAddressPageState extends State<YourAddressPage> {
  final TextEditingController _stateController = TextEditingController(text: "Kaduna");
  final TextEditingController _lgaController = TextEditingController(text: "Chikun");
  final TextEditingController _addressController =
  TextEditingController(text: "No 2 Usman Road, Barnawa. Kaduna");

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
          "Your Address",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF9F9FB),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel("State"),
              _buildTextField(_stateController),
              const SizedBox(height: 16),

              _buildLabel("Local Government Area"),
              _buildTextField(_lgaController),
              const SizedBox(height: 16),

              _buildLabel("Address"),
              _buildTextField(_addressController),
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
                    ); // Handle update request here
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Color(0xFF3F2771)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Request for Update",
                    style: TextStyle(
                      color: Color(0xFF3F2771),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
    );
  }

  Widget _buildTextField(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: Bcolor.enabledBorder,
      ),
    );
  }
}
