import 'package:flutter/material.dart';
import 'package:green_wallet/pages/Startup.dart';
import 'package:green_wallet/widgets/Navigation_bar.dart';
import 'package:green_wallet/Card/Invoice.dart';
import 'package:green_wallet/Card/VCard.dart';

import 'hompage.dart';


class ProfileP extends StatefulWidget {
  const ProfileP({super.key});

  @override
  State<ProfileP> createState() => _ProfilePState();
}

class _ProfilePState extends State<ProfileP> {
  int _selectedIndex = 3;

  // List of screens (widgets) for navigation
  final List<Widget> _pages = [
    const homepage(),
    const VCard(),
    const Invoice(),
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
                    _buildMenuItem(Icons.person, "Account Information"),
                    _buildMenuItem(Icons.verified, "Account Verification", trailing: _buildVerifiedBadge()),
                    _buildMenuItem(Icons.notifications, "Notifications"),
                    const SizedBox(height: 16),
                    _buildSectionTitle("ACCOUNT"),
                    _buildMenuItem(Icons.credit_card, "Cards & Beneficiaries"),
                    const SizedBox(height: 16),
                    _buildSectionTitle("SECURITY"),
                    _buildMenuItem(Icons.security, "Security Settings"),
                    _buildMenuItem(Icons.support, "Help & Support"),
                    _buildMenuItem(Icons.info, "Terms & Conditions"),
                    _buildMenuItem(Icons.privacy_tip, "Privacy Policy"),
                    const SizedBox(height: 20),
                    Center(
                      child: TextButton(
                        onPressed: () async {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return Dialog(
                                backgroundColor: Colors.transparent,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF3F2771),
                                  ),
                                ),
                              );
                            },
                          );

                          // Simulate loading
                          // await Future.delayed(Duration(seconds: 2));
                          // Navigator.of(context).pop();
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => const Startup()),);
                        },
                        child: const Text(
                          "Log Out",
                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, bottom: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF3F2771),

      ),
      child: Column(
        children: [
          const CircleAvatar( backgroundImage: AssetImage("assets/photo.png"),
            radius: 30,
          ),
          const SizedBox(height: 8),
          const Text(
            "Abdul Gafar",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {Widget? trailing}) {
    return Container(
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
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
          if (trailing != null) trailing,
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
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
