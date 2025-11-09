import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Card/homepage.dart';
import '../services/auth_service.dart';

class Topup extends StatefulWidget {
  const Topup({super.key});

  @override
  State<Topup> createState() => _TopupState();
}

class _TopupState extends State<Topup> {
  bool _isLoading = true;
  Map<String, String> _details = {
    "account_name": "",
    "bank_name": "",
    "account_number": "",
  };

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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 1),
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
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
          "Top Up",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF3F2771)))
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    top: 20, left: 10, right: 10, bottom: 10),
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
                    const Spacer(),

                    // Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                const HomeContainer()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3F2771),
                          padding:
                          const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          "I have made the transfer",
                          style: TextStyle(
                              fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}