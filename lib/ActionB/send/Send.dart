import 'package:flutter/material.dart';
import 'package:green_wallet/ActionB/send/intSend.dart';
import 'package:green_wallet/ActionB/send/ngnSend.dart';
import 'package:green_wallet/ActionB/send/walletSend.dart'; // 👈 Add this import for wallet transfer page

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
        child: SingleChildScrollView(
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

              // Wallet Transfer Section
              const Text(
                "Wallet transfer",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 10),

              _buildTransferOption(
                title: "Green Wallet Transfer",
                subtitle: "Send money instantly to another Green Wallet user",
                icon: Icons.account_balance_wallet_outlined,
                iconColor: Colors.green,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WalletSend()),
                  );
                },
              ),

              const SizedBox(height: 20),

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
                icon: Icons.account_balance_outlined,
                iconColor: Colors.green.shade700,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ngnSend()),
                  );
                },
              ),

              // International Transfer Option
              _buildTransferOption(
                title: "Send Internationally",
                subtitle: "Make transfer to international bank accounts across different countries",
                icon: Icons.public_outlined,
                iconColor: Colors.teal,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const intSend()),
                  );
                },
              ),
            ],
          ),
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
              backgroundColor: const Color(0xFF3F2771),
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

  // Reusable Transfer Option Card
  Widget _buildTransferOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: iconColor.withOpacity(0.15),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
