import 'package:flutter/material.dart';
import 'package:green_wallet/ActionB/SendBngn.dart';

class ngnSend extends StatefulWidget {
  const ngnSend({super.key});

  @override
  State<ngnSend> createState() => _ngnSendState();
}

class _ngnSendState extends State<ngnSend> {
  String? selectedBank;
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();

  // Sample Bank List
  final List<String> banks = ["Access Bank", "GTBank", "Zenith Bank", "UBA", "First Bank"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Send to bank account",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bank Selection
            const Text("Bank"),
            const SizedBox(height: 5),
            DropdownButtonFormField<String>(
              value: selectedBank,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              hint: const Text("Select bank"),
              onChanged: (value) {
                setState(() {
                  selectedBank = value;
                });
              },
              items: banks.map((bank) {
                return DropdownMenuItem<String>(
                  value: bank,
                  child: Text(bank),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Account Number Field
            const Text("Account number"),
            const SizedBox(height: 5),
            TextField(
              controller: accountNumberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "1234567890",
                counterText: "",
                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              maxLength: 10,

              onChanged: (value) {
                setState(() {}); // Update UI
              },
            ),
            const SizedBox(height: 20),

            // Full Name Field
            const Text("Full name"),
            const SizedBox(height: 5),
            TextField(
              controller: fullNameController,
              readOnly: true, // User cannot type manually
              decoration: InputDecoration(
                hintText: "Tap here to lookup account",
                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onTap: () {
                // Simulate account lookup logic
                setState(() {
                  fullNameController.text = "John Doe"; // Example response from API
                });
              },
            ),
            const Spacer(),

            // Next Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (selectedBank != null && accountNumberController.text.isNotEmpty)
                    ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Sendbngn()),
                  );// Handle Next Button Action
                }
                    : null, // Disable if fields are empty
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F2771), // Purple button
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  "Next",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}