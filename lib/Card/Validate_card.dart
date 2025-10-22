import 'package:flutter/material.dart';
import 'package:green_wallet/KycTier2/Selfie.dart';

class ValidateCard extends StatefulWidget {
  const ValidateCard({super.key});

  @override
  State<ValidateCard> createState() => _ValidateCardState();
}

class _ValidateCardState extends State<ValidateCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text(
          "Validate User",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
        
              // Illustration Placeholder
              Image.asset(
                'assets/illustration.png', // Replace with your illustration asset
                height: 280,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 30),
        
              // "Take a Selfie" Button
              Container(
                decoration: BoxDecoration(
                  backgroundBlendMode: BlendMode.darken,
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: const Center(
                    child: Text(
                      "Take a selfie",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 150),
        
              // "Validate User" Button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Selfie()),
                  );// Add validation logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F2771),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  minimumSize: const Size(double.infinity, 50), // Full-width button
                ),
                child: const Text(
                  "Validate User",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}