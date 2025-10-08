import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:green_wallet/ActionB/Convert.dart';
import 'package:green_wallet/ActionB/MoreP.dart';
import 'package:green_wallet/ActionB/Send.dart';
import 'package:green_wallet/ActionB/TopUp.dart';
import 'package:green_wallet/Card/Invoice.dart';
import 'package:green_wallet/Card/VCard.dart';
import 'package:green_wallet/Card/Profile.dart';
import 'package:green_wallet/pages/BVN_entry.dart';
import 'package:green_wallet/services/auth_service.dart';
import 'package:green_wallet/widgets/Navigation_bar.dart';
import 'package:green_wallet/widgets/profileheader.dart';
import 'package:green_wallet/pages/NoticeID.dart';
import 'package:http/http.dart' as http;

// Helper method for bottom navigation items

class hompage extends StatefulWidget {
  const hompage({super.key});

  @override
  State<hompage> createState() => _hompageState();
}

class _hompageState extends State<hompage> {
  int _selectedIndex = 0;

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

// Helper method for action buttons
Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
  return Column(
    children: [
      GestureDetector(
        onTap: onTap,
        child: CircleAvatar(
          backgroundColor: Colors.white.withOpacity(0.2),
          child: Icon(icon, color: Colors.white),
        ),
      ),
      const SizedBox(height: 6),
      Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    ],
  );
}

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  bool _isObscured = true;
  String _fullName = "Loading..."; // Default value
  String _kycTier = "0"; // Default: not verified

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    String? token = await AuthService.getToken(); // ✅ fetch from storage

    if (token == null) {
      print("❌ No token found");
      return;
    }

    final url =
        "https://greenwallet-6a1m.onrender.com/api/users/profile?token=$token";
    final response =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      setState(() {
        _fullName = data['full_name'] ?? "User";
        _kycTier = data['kyc_tier']?.toString() ?? "0";
      });

      await AuthService.saveUserProfile(
        data['full_name'] ?? "User",
        data['email'] ?? "Unknown",
      );

      await AuthService.saveKycTier(_kycTier);
    } else {
      debugPrint("❌ Profile fetch failed: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3F2771), // Purple background
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            // Header Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const ProfileHeader(),
                  // Notification Icon
                  CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: const Icon(Icons.notifications, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Main Content Section
            Stack(
              children: [
                // Purple Background
                Container(
                  height: MediaQuery.of(context).size.height * 0.771,
                  color: const Color(0xFF3F2771), // Purple background
                ),

                // White Card Section
                Positioned(
                  top: 158,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    // Responsive height: take 50% of screen height
                    height: MediaQuery.of(context).size.height * 0.60,
                    width: double.infinity, // Full width of the screen
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: _kycTier == "1"
                        ? _buildUpgradeToTier2()
                        : _buildVerifyBvnSection(),
                  ),
                ),

                // Account Balance Section
                Positioned(
                  top: 0,
                  left: 20,
                  right: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1D1039),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Stack(
                      children: [
                        // Background gold coins image
                        Positioned(
                          top: 0, // Start at the top
                          right: 0, // Align to the extreme right
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(16),
                            ),
                            child: Image.asset(
                              'assets/gold_coins.png', // Replace with your image asset
                              height: 100, // Adjust height as needed
                              fit: BoxFit
                                  .contain, // Ensures the image fits within bounds
                            ),
                          ),
                        ),
                        // Content on top of the image
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Account Balance",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _isObscured ? "******" : "\$1,000,000",
                                    semanticsLabel: "\$1,000,000",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  IconButton(
                                    icon: Icon(
                                      _isObscured
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isObscured =
                                            !_isObscured; // Toggle visibility
                                      });
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildActionButton(
                                      Icons.currency_exchange, "Convert", () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Convert()),
                                    );
                                  }),
                                  _buildActionButton(Icons.send, "Send", () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Transfer()),
                                    );
                                  }),
                                  _buildActionButton(Icons.add, "Top-up", () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const Topup()),
                                    );
                                  }),
                                  _buildActionButton(Icons.more_horiz, "More",
                                      () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const Morep()),
                                    );
                                  }),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

// 🟣 Shown if user has NOT verified BVN (kyc_tier != 1)
  Widget _buildVerifyBvnSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        Image.asset(
          'assets/virtual_card_image.png',
          height:
              MediaQuery.of(context).size.height * 0.20, // 20% of screen height
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 20),
        const Text(
          "Verify Your BVN",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "Instantly verify your BVN to make managing online payments easy",
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BvnEntry()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3F2771),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            minimumSize: const Size(double.infinity, 50), // Full width
          ),
          child: const Text(
            "Verify BVN",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }

// 🟢 Shown if KYC Tier 1 is already completed
  Widget _buildUpgradeToTier2() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.verified, color: Colors.green, size: 80),
        const SizedBox(height: 20),
        const Text(
          "You're verified to Tier 1!",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text(
          "Upgrade to Tier 2 to unlock more features",
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Navigate to Tier 2 upgrade screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NoticeId()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF3F2771),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text(
            "Upgrade to Tier 2",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
