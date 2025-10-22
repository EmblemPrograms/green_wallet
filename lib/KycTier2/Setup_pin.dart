import 'package:flutter/material.dart';
import 'package:green_wallet/KycTier2/Select_pin.dart';

class SetupPin extends StatefulWidget {
  const SetupPin({super.key});

  @override
  State<SetupPin> createState() => _SetupPinState();
}

class _SetupPinState extends State<SetupPin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image Section
            SizedBox(height: 30,),
            Image.asset(
              'assets/Signup.png',
              height: 200, // Adjust size as per your design
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 40),

            // Title
            const Text(
              'Set up your PIN',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Description
            const Text(
              'Your PIN is a fast, secure and easy way to sign in to your account and to authorize all your transactions.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                height: 1.5, // Adjust line height for better readability
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 150),

            // Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                      context, MaterialPageRoute(builder: (context) => SelectPin())); // Navigate to PIN setup screen
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: const Color(0xFF3F2771), // Purple button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'Setup PIN',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}