import 'package:flutter/material.dart';
import 'package:green_wallet/ActionB/ReasonInt.dart';

class SendBint extends StatefulWidget {
  const SendBint({super.key});

  @override
  State<SendBint> createState() => _SendBintState();
}

class _SendBintState extends State<SendBint> {
  final TextEditingController _amountController = TextEditingController();
  String selectedCurrency = "NGN"; // Default currency

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Send to Abdul Gafar",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "USD 100.20 Available",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // "You send" text
            const Text(
              "You send",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),

            // Amount input field with currency selector
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  // Currency selector
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: DropdownButton<String>(
                      value: selectedCurrency,
                      underline: Container(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCurrency = newValue!;
                        });
                      },
                      items: <String>["NGN", "USD", "EUR"].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Row(
                            children: [
                              Image.asset("assets/us_flag.png", width: 24), // Replace with a proper flag asset
                              const SizedBox(width: 5),
                              Text(value, style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const VerticalDivider(width: 1, color: Colors.grey),

                  // Amount input field
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "0.00",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        prefixText: "\$ ",
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Next button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReasonInt()),
                  );// Handle Next Button action

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F2771), // Purple color
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