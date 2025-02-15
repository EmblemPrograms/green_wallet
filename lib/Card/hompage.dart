import 'package:flutter/material.dart';
import 'package:green_wallet/ActionB/Convert.dart';
import 'package:green_wallet/Card/Invoice.dart';
import 'package:green_wallet/Card/VCard.dart';
import 'package:green_wallet/Card/Profile.dart';
import 'package:green_wallet/widgets/Navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Virtual.dart';

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
      // bottomNavigationBar: BottomAppBar(
      //   height: 70,
      //   shape: const CircularNotchedRectangle(),
      //   // Adds notch for FloatingActionButton
      //   notchMargin: 8.0,
      //   color: Colors.white,
      //   child: Padding(
      //     padding: const EdgeInsets.symmetric(horizontal: 2),
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: [
      //         _buildBottomNavItem(Icons.home_rounded, "Home", 0),
      //         _buildBottomNavItem(Icons.credit_card, "Card", 1),
      //         _buildBottomNavItem(Icons.edit_calendar_rounded, "Invoice", 2),
      //         _buildBottomNavItem(Icons.account_balance, "Account", 3),
      //       ],
      //     ),
      //   ),
      // ),
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

  @override
  void initState() {
    super.initState();
    _loadFullName();
  }
  Future<void> _loadFullName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _fullName = prefs.getString("full_name") ?? "User";
    });
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
                  // User Info Section
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        radius: 20,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Good Morning",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          SizedBox(height: 4),
                          Text(
                            _fullName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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
                  height: 580, // Adjust the height as needed
                  color: const Color(0xFF3F2771), // Purple background
                ),

                // White Card Section
                Positioned(
                  top: 160,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    height: 420,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        Image.asset(
                          'assets/virtual_card_image.png', // Replace with your image asset
                          height: 150,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Create a Virtual Card",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Instantly create a virtual card to make managing online payments easy",
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
                              MaterialPageRoute(
                                  builder: (context) => const Virtual()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3F2771),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text(
                            "Get a Virtual Card",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
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
                                            !_isObscured; // Toggle password visibility
                                      });
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
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
                                              const Virtual()),
                                    );
                                  }),
                                  _buildActionButton(Icons.add, "Top-up", () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Virtual()),
                                    );
                                  }),
                                  _buildActionButton(Icons.more_horiz, "More",
                                      () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Virtual()),
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
}
