import 'package:flutter/material.dart';
import 'package:green_wallet/KycTier2/Notice.dart';
import 'package:green_wallet/KycTier2/NoticeID.dart';

class Continue extends StatefulWidget {
  const Continue({super.key});

  @override
  State<Continue> createState() => _ContinueState();
}

class _ContinueState extends State<Continue> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoticeId(),
                ),
              );
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Let’s Verify your Identity",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "To get verified, you will need to:",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 100),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.only(right: 6, top: 16),
              child: Column(
                children: [

                  const SizedBox(height: 35),
                  _buildVerificationStep(
                    icon: Icons.image,
                    text: "Upload  photos of document proving your identity",
                  ),
                ],
              ),
            ),
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF442266), // Dark purple color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Notice(),
                  ),
                );// Handle continue button click
              },
              child: Text(
                "Continue",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationStep({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.purple.shade100,
            child: Icon(icon, color: Colors.purple, size: 30),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}