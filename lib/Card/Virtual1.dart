import 'package:flutter/material.dart';
import 'package:green_wallet/pages/BVN_entry.dart';

class Virtual1 extends StatefulWidget {
  const Virtual1({super.key});

  @override
  State<Virtual1> createState() => _Virtual1State();
}

class _Virtual1State extends State<Virtual1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // Title
            const Text(
              "Confirm one-time fee",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),

            ),
            const SizedBox(height: 30),

            // Card Image
            Image.asset(
              'assets/virtual_card.png', // Replace with the actual asset path
              height: 180,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 30),

            // Description Text
            const Text(
              "A one-time fee of \$1.00 will be charged for card creation, and an additional \$2.00 will be deducted from your balance to fund the card.\n\nDo you agree to this?",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),

            // "Yes" Button
            ElevatedButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return Dialog(
                      backgroundColor: Colors.transparent,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF3F2771),
                        ),
                      ),
                    );
                  },
                );

                // Simulate loading
                await Future.delayed(Duration(seconds: 2));
                Navigator.of(context).pop();
                // Add your logic to create a virtual card
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BvnEntry()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3F2771), // Purple color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                "Yes, create my Virtual Card",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(height: 15),

            // "No" Button
            ElevatedButton(
              onPressed: () {
                // Add your logic to go back
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEDE7F6), // Light purple color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                "No, take me back",
                style: TextStyle(fontSize: 16, color: Color(0xFF3F2771)),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}