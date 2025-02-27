import 'package:flutter/material.dart';
import 'package:green_wallet/Card/Virtual1.dart';

class Virtual extends StatefulWidget {
  const Virtual({super.key});

  @override
  State<Virtual> createState() => _VirtualState();
}

class _VirtualState extends State<Virtual> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // Virtual card image
            Image.asset(
              'assets/virtual_card.png', // Replace with your image asset path
              height: 200,
              width: double.infinity,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 20),

            // Virtual Card Title
            const Text(
              "Virtual",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),

            // Virtual Card Subtitle
            const Text(
              "Create a virtual card instantly and enjoy hassle-free online payments. "
                  "Say goodbye to the stress of losing your card!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),

            // Color Selector Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildColorCircle(Colors.blue, true),
                const SizedBox(width: 16),
                _buildColorCircle(Colors.yellow, false),
                const SizedBox(width: 16),
                _buildColorCircle(Colors.green, false),
                const SizedBox(width: 16),
                _buildColorCircle(Colors.lightGreen, false),
              ],
            ),

            const Spacer(),

            // Create Virtual Card Button
            ElevatedButton(
              onPressed: () {
                // Handle create virtual card action
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Virtual1()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3F2771), // Button color
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                "Create Virtual Card",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildColorCircle(Color color, bool isSelected) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: isSelected
            ? Border.all(color: Colors.blue, width: 3)
            : Border.all(color: Colors.transparent, width: 3),
      ),
    );
  }
}