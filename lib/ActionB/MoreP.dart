import 'package:flutter/material.dart';
import 'package:green_wallet/ActionB/CardLimits.dart';
import 'package:green_wallet/ActionB/ManageC.dart';

class Morep extends StatefulWidget {
  const Morep({super.key});

  @override
  State<Morep> createState() => _MorepState();
}

class _MorepState extends State<Morep> {
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
          "Card settings",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // Delete Card
              _buildSettingsItem(
                title: "Delete Card",
                description: "Delete your card and return to your wallet. Deleted cards will not incur decline fees.",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ManageC()),
                  );
                },
              ),
              _buildDivider(),

              // Freeze Card
              _buildSettingsItem(
                title: "Freeze Card",
                description: "Freezing your card will cause all transaction attempts to be declined, and any declined transactions may still incur fees.",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ManageC()),
                  );
                },
              ),
              _buildDivider(),

              // Decline Card (with navigation)
              _buildSettingsItem(
                title: "Decline Card",
                description: "Learn about decline fees and links to resources about your card.",
                onTap: () {
                  // Navigate to another screen
                },
                showArrow: true,
              ),
              _buildDivider(),

              // Card Limits (with navigation)
              _buildSettingsItem(
                title: "Card Limits",
                description: "View your card limits",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CardLimits()),
                  );// Navigate to card limits page
                },
                showArrow: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required String title,
    required String description,
    required VoidCallback onTap,
    bool showArrow = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            if (showArrow)
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(color: Colors.grey.shade300, thickness: 0.8);
  }
}