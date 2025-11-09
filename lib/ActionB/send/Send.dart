import 'package:flutter/material.dart';
import 'package:green_wallet/ActionB/send/intSend.dart';
import 'package:green_wallet/ActionB/send/ngnSend.dart';

class Transfer extends StatefulWidget {
  const Transfer({super.key});

  @override
  State<Transfer> createState() => _TransferState();
}

class _TransferState extends State<Transfer> {
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
          "Transfer",
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
            // Send Again Section
            const Text(
              "Send again",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 10),

            // Row for recent contacts
            Row(
              children: [
                _buildRecentContact("W", "🇳🇬"), // Nigeria
                const SizedBox(width: 15),
                _buildRecentContact("W", "🇺🇸"), // USA
                const SizedBox(width: 15),
                _buildRecentContact("W", "🇬🇧"), // UK
              ],
            ),

            const SizedBox(height: 30),

            // Bank Transfer Section
            const Text(
              "Bank transfer",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 10),

            // NGN Bank Transfer Option
            _buildTransferOption(
              title: "NGN Bank Accounts",
              subtitle: "Make transfer to Nigerian bank accounts",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ngnSend()),
                );// Navigate to NGN bank transfer screen
              },
            ),

            // International Transfer Option
            _buildTransferOption(
              title: "Send Internationally",
              subtitle: "Make transfer to international bank accounts across different countries",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => intSend()),
                );// Navigate to International transfer screen
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget for recent contacts with country flag
  Widget _buildRecentContact(String initial, String flag) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: const Color(0xFF3F2771), // Dark purple
              child: Text(
                initial,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              bottom: 2,
              right: 2,
              child: Text(
                flag,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        const Text(
          "Wisdom",
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  // Widget for transfer options
  Widget _buildTransferOption(
      {required String title, required String subtitle, required VoidCallback onTap}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 14, color: Colors.grey),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}
