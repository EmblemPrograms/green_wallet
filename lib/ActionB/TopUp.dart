import 'package:flutter/material.dart';
import 'package:green_wallet/ActionB/TopUpD.dart';
import 'package:green_wallet/widgets/textborder.dart';

class Topup extends StatefulWidget {
  const Topup({super.key});

  @override
  State<Topup> createState() => _TopupState();
}

class _TopupState extends State<Topup> {
  String? selectedFundSource;
  final TextEditingController amountController = TextEditingController();

  // List of sources of funds
  final List<String> fundSources = ["Bank Transfer", "Credit Card", "PayPal"];

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
          "Top Up",
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
            // Source of Fund Dropdown
            const Text("Source of Fund"),
            const SizedBox(height: 5),
            DropdownButtonFormField<String>(
              value: selectedFundSource,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                enabledBorder: Bcolor.enabledBorder,
              ),
              hint: const Text("Select source of funds"),
              onChanged: (value) {
                setState(() {
                  selectedFundSource = value;
                });
              },
              items: fundSources.map((source) {
                return DropdownMenuItem<String>(
                  value: source,
                  child: Text(source),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Amount Text Field
            const Text("Amount"),
            const SizedBox(height: 5),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter amount",
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                enabledBorder: Bcolor.enabledBorder,
              ),
              onChanged: (value) {
                setState(() {}); // Update the button state
              },
            ),
            const Spacer(),

            // Top Up Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (selectedFundSource != null &&
                        amountController.text.isNotEmpty)
                    ? () {
                  double? enteredAmount =
                  double.tryParse(amountController.text);
                  if (enteredAmount != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Topupd(
                          fundAmount: enteredAmount,
                          fundingFee: 0.00,
                          destination: "Dollar card",
                        ),
                      ),
                    );
                  } else {
                    // Show error message if the amount is not valid
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please enter a valid amount"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
                    : null, // Button is disabled when inputs are empty
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F2771), // Purple button
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  "Top Up",
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
