import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:green_wallet/Card/hompage.dart';

class AccountDetails extends StatefulWidget {
  const AccountDetails({super.key});

  @override
  State<AccountDetails> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Copied to clipboard")),
    );
  }

  Widget _buildAccountDetailRow(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F1FC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(
              Icons.copy,
              color: Color(0xFF3F2771),
              size: 20,
            ),
            onPressed: () => _copyToClipboard(value),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3F2771),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3F2771),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
         onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Account Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          // Icon in the middle
          Center(
            child: Image.asset(
              'assets/user shield.png', // Path to your local image
              width: 80, // Adjust size as needed
              height: 90,
              fit: BoxFit.contain, // Ensures proper scaling
            ),
          ),
          const SizedBox(height: 20),

          // Details section
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(
                top: 30,
                left: 20,
                right: 20,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  _buildAccountDetailRow("Account Holder", "Abdul Gafar"),
                  _buildAccountDetailRow(
                      "Bank Name", "hjlsaknfn;na j;jil;lnljlkbauVHVU"),
                  _buildAccountDetailRow("Account Number", "324152637489"),
                  _buildAccountDetailRow("Sort Code", "193245"),
                  _buildAccountDetailRow(
                      "Address", "16B Ahmadu Bello way, Kaduna State. Nigeria"),
                  const SizedBox(height: 20),

                  SizedBox(
                    height: 10,
                  ),

                  // Share button
                  TextButton.icon(
                    onPressed: () {
                      // Handle share action
                    },
                    icon:
                        const Icon(Icons.share_sharp, color: Color(0xFF3F2771)),
                    label: const Text(
                      'Share',
                      style: TextStyle(color: Color(0xFF3F2771)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
