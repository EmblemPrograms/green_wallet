import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:green_wallet/pages/Signin.dart';
import 'package:green_wallet/profile/account_info/Account_info.dart';
import 'package:green_wallet/profile/cardbf.dart';
import 'package:green_wallet/profile/help.dart';
import 'package:green_wallet/profile/noti.dart';
import 'package:green_wallet/profile/security/security.dart';
import 'package:green_wallet/widgets/Navigation_bar.dart';
import 'package:green_wallet/Card/NCard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data';
import '../services/auth_service.dart';
import 'Transfer.dart';
import 'homepage.dart';

class ProfileP extends StatefulWidget {
  const ProfileP({super.key});

  @override
  State<ProfileP> createState() => _ProfilePState();
}

class _ProfilePState extends State<ProfileP> {
  int _selectedIndex = 3;

  // List of screens (widgets) for navigation
  final List<Widget> _pages = [
    const HomepageScreen(),
    const MyCardsPage(),
    const Transfer(),
    const Profile(),
  ];

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onNavItemTapped,
      ),
    );
  }
}

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String _fullName = "Loading..."; // ✅ Declare _fullName

  Uint8List? _selfieBytes;
  String? _selfieUrl;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadSelfie(); // 👈 add this
  }

  Future<void> _loadSelfie() async {
    final profile = await AuthService.getUserProfile();

    final selfieValue = profile["selfie"];
    if (selfieValue != null && selfieValue.isNotEmpty) {
      if (selfieValue.startsWith("http")) {
        setState(() => _selfieUrl = selfieValue);
      } else {
        try {
          setState(() => _selfieBytes = base64Decode(selfieValue));
        } catch (e) {
          debugPrint("Error decoding selfie: $e");
        }
      }
    }
  }
  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _fullName =
          prefs.getString("full_name") ?? "User"; // ✅ Load name dynamically
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildSectionTitle("ACCOUNT"),
                    _buildMenuItem(
                      Icons.person,
                      "Account Information",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AccountInfoScreen()),
                        );
                      },
                    ),
                    _buildMenuItem(Icons.verified, "Account Verification",
                        trailing: _buildVerifiedBadge()),
                    _buildMenuItem(
                      Icons.notifications,
                      "Notifications",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const NotificationsScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildSectionTitle("ACCOUNT"),
                    _buildMenuItem(
                      Icons.credit_card,
                      "Cards & Beneficiaries",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const CardsBeneficiariesPage()),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildSectionTitle("SECURITY"),
                    _buildMenuItem(
                      Icons.security,
                      "Security Settings",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const SecuritySettingsScreen()),
                        );
                      },
                    ),
                    _buildMenuItem(
                      Icons.support,
                      "Help & Support",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Help()),
                        );
                      },
                    ),
                    _buildMenuItem(Icons.info, "Terms & Conditions"),
                    _buildMenuItem(Icons.privacy_tip, "Privacy Policy"),
                    const SizedBox(height: 20),
                    Center(
                      child: TextButton(
                        onPressed: () async {
                          // Show loading dialog
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return const Dialog(
                                backgroundColor: Colors.transparent,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF3F2771),
                                  ),
                                ),
                              );
                            },
                          );

                          // Simulate delay
                          await Future.delayed(const Duration(seconds: 2));

                          // 🔑 Clear user session data
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.remove("auth_token");
                          await prefs.remove("full_name");
                          await prefs.remove("email");
                          await prefs.remove("wallet_balance");
                          await prefs.remove("old_pin");

                          // Close loading dialog
                          Navigator.of(context).pop();

                          // Navigate to Startup page
                          if (context.mounted) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const Signin()),
                                  (route) => false, // Remove all previous pages from stack
                            );
                          }
                        },
                        child: const Text(
                          "Log Out",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    Widget avatarWidget;

    if (_selfieBytes != null) {
      avatarWidget = CircleAvatar(
        radius: 40,
        backgroundImage: MemoryImage(_selfieBytes!),
      );
    } else if (_selfieUrl != null) {
      avatarWidget = CircleAvatar(
        radius: 40,
        backgroundImage: NetworkImage(_selfieUrl!),
      );
    } else {
      avatarWidget = const CircleAvatar(
        radius: 40,
        backgroundImage: AssetImage("assets/photo.png"),
      );
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, bottom: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF3F2771),
      ),
      child: Column(
        children: [
          avatarWidget, // 👈 dynamic image here
          const SizedBox(height: 8),
          Text(
            _fullName,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Text(
            "GreenWallet Account",
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title,
      {Widget? trailing, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Colors.purple.shade50,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: Icon(icon, color: const Color(0xFF3F2771)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
            if (trailing != null) trailing,
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildVerifiedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Text(
        "Verified",
        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
      ),
    );
  }
}
