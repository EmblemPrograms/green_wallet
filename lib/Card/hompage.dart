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
        data['bvn'] ?? "Unknown",
        data['selfie'] ?? "Unknown",
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
                        : _buildTransactionSection(),
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
                                    _isObscured ? "******" : "\$0.00",
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

// 🟣 Shown if user has NOT verified BVN (kyc_tier != 2)
  Widget _buildTransactionSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10,),
          // 🔹 Header Row (Transaction History + View All)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Transaction History",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1D1F),
                ),
              ),
              Text(
                "View All",
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),

          // 🔸 Empty State Icon & Message
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long_rounded,
                  size: 60,
                  color: Colors.grey.withOpacity(0.3),
                ),
                const SizedBox(height: 16),
                const Text(
                  "No transactions yet",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Your recent transactions will appear here.",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black38,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

// 🟢 Shown if KYC Tier 1 is already completed
  Widget _buildUpgradeToTier2() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/Done.png', // Replace with your image
          width: 150, // Matches the Icon size
          height: 150,
          fit: BoxFit.contain,
        ),
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
