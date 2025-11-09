import 'package:flutter/material.dart';
import 'package:green_wallet/ActionB/send/SendBint.dart';

class IntSend1 extends StatefulWidget {
  const IntSend1({super.key});

  @override
  State<IntSend1> createState() => _IntSend1State();
}

class _IntSend1State extends State<IntSend1> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _recipientAddressController = TextEditingController();

  String? selectedBank;
  String? selectedAccountType;

  final List<String> banks = ["Bank of America", "Chase Bank", "Wells Fargo", "Citi Bank"];
  final List<String> accountTypes = ["Current", "Savings"];

  void _selectBank(String? bank) {
    setState(() {
      selectedBank = bank;
    });
  }

  void _selectAccountType(String? type) {
    setState(() {
      selectedAccountType = type;
    });
  }

  void _onNext() {
    // Implement validation and navigation logic
    if (_emailController.text.isNotEmpty &&
        selectedBank != null &&
        _fullNameController.text.isNotEmpty &&
        _accountNumberController.text.isNotEmpty &&
        selectedAccountType != null &&
        _recipientAddressController.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SendBint()),
      );// Proceed to the next step
      print("Form is valid, proceed to next step.");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Send to United States",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 5),
            Text("🇺🇸", style: TextStyle(fontSize: 20)),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              _buildTextField(_emailController, "Email Address", "Enter your email address"),
              SizedBox(height: 10),
              _buildDropdownField("Bank", "Select bank", banks, selectedBank, _selectBank),
              SizedBox(height: 10),
              _buildTextField(_fullNameController, "Full Name", "Tap here to lookup account"),
              SizedBox(height: 10),
              AccountNumberInput(controller: _accountNumberController),
              SizedBox(height: 10),
              _buildDropdownField("Account Type", "Select account type", accountTypes, selectedAccountType, _selectAccountType),
              SizedBox(height: 10),
              _buildTextField(_recipientAddressController, "Recipient Address", "Enter recipient address"),
              SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3F2771),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    "Next",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String hint, {bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        SizedBox(height: 5),
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            filled: true,
            fillColor: Colors.grey.shade100,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, String hint, List<String> items, String? selectedItem, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: selectedItem,
          hint: Text(hint),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            filled: true,
            fillColor: Colors.grey.shade100,
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class AccountNumberInput extends StatelessWidget {
  final TextEditingController controller;

  const AccountNumberInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Account Number", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        SizedBox(height: 5),
        TextField(
          maxLength: 10,
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            counterText: "",
            hintText: "1234567890",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            filled: true,
            fillColor: Colors.grey.shade100,
          ),
        ),
      ],
    );
  }
}