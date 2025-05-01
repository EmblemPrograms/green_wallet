import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:green_wallet/Card/Profile.dart';
import 'package:green_wallet/widgets/textborder.dart';


class AddBeneficiary extends StatefulWidget {
  const AddBeneficiary({super.key});

  @override
  State<AddBeneficiary> createState() => _AddBeneficiaryState();
}

class _AddBeneficiaryState extends State<AddBeneficiary> {
  String? _selectedCountry;
  String? selectedType = 'Individual';

  final List<String> recipientTypes = ['Individual', 'Business'];

  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController sortCodeController = TextEditingController();
  final TextEditingController swiftCodeController = TextEditingController();

  @override
  void dispose() {
    accountNumberController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    sortCodeController.dispose();
    swiftCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Cards & Beneficiaries",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("Recipient’s Currency"),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade100,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: const [
                  Text("🇳🇬"),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "USD Balance",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                ],
              ),
            ),
            _buildLabel("Recipient’s Country"),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFE0E0E0)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedCountry ?? "Select your country",
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            _buildLabel("Recipient’s Type"),
            DropdownButtonFormField<String>(
              value: selectedType,
              items: recipientTypes.map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedType = value;
                });
              },
              decoration: _dropdownDecoration("Select Type"),
            ),
            const SizedBox(height: 15),
            _buildTextField(accountNumberController, "Bank Account Number",
                "Enter recipients account number"),
            _buildTextField(firstNameController, "First Name",
                "Enter recipients first name"),
            _buildTextField(
                lastNameController, "Last Name", "Enter recipients last name"),
            _buildTextField(sortCodeController, "Bank Sort Code",
                "Enter recipients bank sort code"),
            _buildTextField(swiftCodeController, "Bank Swift Code",
                "Enter recipients swift code"),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileP()),
                  );// TODO: Submit data logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F2771),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Add Bank Account",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String hint,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: Bcolor.enabledBorder,
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  InputDecoration _dropdownDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: Bcolor.enabledBorder,
    );
  }
}
