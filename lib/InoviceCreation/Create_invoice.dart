import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:green_wallet/widgets/textborder.dart';
import 'Create_invoice1.dart';

class CreateInvoice extends StatefulWidget {
  const CreateInvoice({super.key});

  @override
  State<CreateInvoice> createState() => _CreateInvoiceState();
}

class _CreateInvoiceState extends State<CreateInvoice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Create an Invoice",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step Indicator
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    _stepIndicator(false, isCurrentStep: true, stepText: "1"),
                    const SizedBox(width: 5),
                    const Text(
                      "Recipient Information",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 60),
                    _stepIndicator(false, stepText: "2"),
                    _stepIndicator(false, stepText: "3"),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Input Fields
              const Text(
                "Recipient Name",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              const SizedBox(height: 8),
              _buildTextField("Enter recipient’s name"),

              const SizedBox(height: 16),
              const Text(
                "Client’s Email Address",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              const SizedBox(height: 8),
              _buildTextField("Enter recipient’s email address"),

              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Billing Address",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  Text(
                    "Optional",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildBillingAddressField(),

              const SizedBox(height: 220), // Fixed issue with Spacer()

              // Next Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3F2771),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateInvoice1()),
                    );
                  },
                  child: const Text("Next",
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: Bcolor.enabledBorder,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildBillingAddressField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFE0E0E0)),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Add Billing Address",
              style: TextStyle(color: Colors.grey)),
          IconButton(
            icon: const Icon(Icons.add_circle, color: Color(0xFF3F2771)),
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => CustomDialogWidget(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _stepIndicator(bool isCompleted,
      {bool isCurrentStep = false, String? stepText}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: CircleAvatar(
        radius: 14,
        backgroundColor: isCurrentStep
            ? const Color(0xFF3F2771)
            : (isCompleted ? const Color(0xFF3F2771) : const Color(0xFFE0E0E0)),
        child: isCompleted
            ? const Icon(Icons.check, color: Colors.white, size: 16)
            : Text(
                stepText ?? "",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}

class CustomDialogWidget extends StatefulWidget {
  const CustomDialogWidget({super.key});

  @override
  State<CustomDialogWidget> createState() => _CustomDialogWidgetState();
}

class _CustomDialogWidgetState extends State<CustomDialogWidget> {
  String? _selectedCountry;
  bool showOtherInfo = false; // ✅ This variable must be present

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Close Icon and Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Billing Address",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Street Input
              buildTextField("Street", "Enter street"),
              const SizedBox(height: 10),

              // City Input
              buildTextField("City", "Enter street"),
              const SizedBox(height: 10),

              // State Input
              buildTextField("State", "Enter state"),
              const SizedBox(height: 10),

              // Country Dropdown
              buildDropdownField("Country"),
              const SizedBox(height: 15),

              // Other Information
              InkWell(
                onTap: () {
                  setState(() {
                    showOtherInfo = !showOtherInfo;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Other information",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 5),
                    Icon(
                      showOtherInfo
                          ? Icons.remove_circle_outline
                          : Icons.add_circle_outline,
                      color: Color(0xFF3F2771),
                    ),
                  ],
                ),
              ),

              // Expandable Section
              if (showOtherInfo)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: buildTextField("Additional Notes", "Enter details"),
                ),

              const SizedBox(height: 20),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Save action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3F2771),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    "Save",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable TextField Widget
  Widget buildTextField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 5),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: Bcolor.enabledBorder,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          ),
        ),
      ],
    );
  }

  // Country Dropdown Field
  Widget buildDropdownField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500),
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
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
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
      ],
    );
  }
}
