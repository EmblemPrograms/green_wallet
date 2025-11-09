import 'package:flutter/material.dart';
import 'package:green_wallet/ActionB/ReasonNgn.dart';

class Sendbngn extends StatefulWidget {
  const Sendbngn({super.key});

  @override
  State<Sendbngn> createState() => _SendbngnState();
}

class _SendbngnState extends State<Sendbngn> {
  final TextEditingController amountController = TextEditingController();
  String currency = "NGN"; // Default currency

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
        title: const Column(
          children: [
            Text(
              "Send to Abdul Gafar",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "NGN 100.20 Available",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("You send"),
            const SizedBox(height: 10),

            // Currency & Amount Input Field
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                children: [
                  // Currency Selector with Flag
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.grey.shade200,
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/ngn_flag.png', // Replace with your NGN flag asset
                          height: 20,
                          width: 20,
                        ),
                        const SizedBox(width: 5),
                        const Text("NGN"),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Amount Input
                  Expanded(
                    child: TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "0.00",
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {}); // Update button state
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),

            // Next Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: amountController.text.isNotEmpty
                    ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Reasonngn()),
                  );// Handle Next Button Action
                }
                    : null, // Disable if input is empty
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