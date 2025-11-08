import 'package:flutter/material.dart';
import 'package:green_wallet/InoviceCreation/preview.dart';
import 'package:green_wallet/widgets/textborder.dart';

class CreateInvoice2 extends StatefulWidget {
  const CreateInvoice2({super.key});

  @override
  State<CreateInvoice2> createState() => _CreateInvoice2State();
}

class _CreateInvoice2State extends State<CreateInvoice2> {
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
          "Card Details",
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
                    _stepIndicator(true),
                    _stepIndicator(true),
                    _stepIndicator(false, isCurrentStep: true, stepText: "3"),
                    const SizedBox(width: 8),
                    const Text(
                      "Receiving account details",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Input Fields
              const Text("Card Name", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
              const SizedBox(height: 8),
              _buildTextField("Enter your card name"),

              const SizedBox(height: 16),
              const Text("Card Number", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
              const SizedBox(height: 8),
              _buildTextField("Enter your card number"),

              const SizedBox(height: 16),
              const Text("CVV No.", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
              const SizedBox(height: 8),
              _buildTextField("Enter your CVV no here"),

              SizedBox(height: 250),

              // Preview Button
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
                          builder: (context) =>
                          const InvoicePreview()),
                    );
                  },
                  child: const Text("Preview", style: TextStyle(fontSize: 16, color: Colors.white)),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _stepIndicator(bool isCompleted, {bool isCurrentStep = false, String? stepText}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: CircleAvatar(
        radius: 14,
        backgroundColor: isCurrentStep ? const Color(0xFF3F2771) : (isCompleted ? const Color(0xFF3F2771) : const Color(0xFFE0E0E0)),
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