import 'package:flutter/material.dart';
import 'package:green_wallet/ActionB/ReviewNgn.dart';

class Reasonngn extends StatefulWidget {
  const Reasonngn({super.key});

  @override
  State<Reasonngn> createState() => _ReasonngnState();
}

class _ReasonngnState extends State<Reasonngn> {
  final TextEditingController _noteController = TextEditingController();

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
          "Reason for payment",
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
            const Text("Note"),
            const SizedBox(height: 10),

            // Transfer Narration Input
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                hintText: "Enter Transfer Narration",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              ),
              onChanged: (value) {
                setState(() {}); // Update button state
              },
            ),
            const Spacer(),

            // Next Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _noteController.text.isNotEmpty
                    ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReviewNgn()),
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
