import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';

import '../services/auth_service.dart'; // For sharing account details

class AccountDetails extends StatefulWidget {
  const AccountDetails({super.key});

  @override
  State<AccountDetails> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  bool _isLoading = true;
  Map<String, String> _details = {
    "account_name": "",
    "bank_name": "",
    "account_number": "",
    "nip_code": "",
  };

  // Copy to clipboard
  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Copied to clipboard")),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadAccountDetails();
  }

  Future<void> _loadAccountDetails() async {
    try {
      // Fetch and save latest profile
      await AuthService.fetchAndSaveUserProfile();
    } catch (e) {
      debugPrint('Error fetching profile: $e');
    }

    // Then load from local storage
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _details = {
        "account_name": prefs.getString("account_name") ?? "N/A",
        "bank_name": prefs.getString("bank_name") ?? "N/A",
        "account_number": prefs.getString("account_number") ?? "N/A",
        "nip_code": prefs.getString("nip_code") ?? "N/A",
      };
      _isLoading = false;
    });
  }


  // Widget for each account detail row
  Widget _buildAccountDetailRow(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F1FC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
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
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
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

  // Share all account details
  void _shareDetails() {
    final shareText = '''
Account Holder: ${_details["account_name"]}
Bank Name: ${_details["bank_name"]}
Account Number: ${_details["account_number"]}
Sort Code: ${_details["nip_code"]}
    ''';
    Share.share(shareText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3F2771),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3F2771),
        elevation: 0,
        leading: IconButton(
          icon:
          const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Column(
        children: [
          const SizedBox(height: 20),

          // Icon
          Center(
            child: Image.asset(
              'assets/user shield.png',
              width: 80,
              height: 90,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 20),

          // Details section
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(
                  top: 30, left: 20, right: 20, bottom: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  _buildAccountDetailRow(
                      "Account Holder", _details["account_name"] ?? ""),
                  _buildAccountDetailRow(
                      "Bank Name", _details["bank_name"] ?? ""),
                  _buildAccountDetailRow(
                      "Account Number", _details["account_number"] ?? ""),
                  const SizedBox(height: 20),

                  // Share button
                  TextButton.icon(
                    onPressed: _shareDetails,
                    icon: const Icon(Icons.share_sharp,
                        color: Color(0xFF3F2771)),
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
