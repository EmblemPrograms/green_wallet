import 'package:flutter/material.dart';
import 'package:green_wallet/widgets/Navigation_bar.dart';
import 'package:green_wallet/Card/hompage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Invoice.dart';
import 'Profile.dart';

class CardP extends StatefulWidget {
  const CardP({super.key});

  @override
  State<CardP> createState() => _CardPState();
}

class _CardPState extends State<CardP> {
  int _selectedIndex = 1;

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

class VCard extends StatefulWidget {
  const VCard({super.key});

  @override
  State<VCard> createState() => _VCardState();
}

class _VCardState extends State<VCard> {
  String _fullName = "Loading..."; // ✅ Declare _fullName

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _fullName = prefs.getString("full_name") ?? "User"; // ✅ Load name dynamically
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Light grey background
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF3F2771)),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const hompage()),);
          },
        ),
        title: const Text("My Virtual Card"),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            top: 40.0,
            right: 20.0,
            left: 20.0),

        child: _buildVirtualCard(),
      ),
    );
  }
  Widget _buildVirtualCard() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/gw1 2.png"),
          fit: BoxFit.scaleDown,

        ),
        color: const Color(0xFF3F2771), // Deep purple background
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // GreenWallet logo (Top Right)
          Positioned(
            top: 16,
            right: 16,
            child: Row(
              children: [
                Image.asset(
                  "assets/gw21.png", // Add your logo asset
                  width: 90,

                ),
              ],
            ),
          ),

          // Card Chip (Top Left)
          Positioned(
            top: 20,
            left: 16,
            child: Image.asset(
              "assets/chip.png", // Add your chip asset
              width: 40,
            ),
          ),

          // Card Number (Masked)
          Positioned(
            top: 70,
            left: 16,
            child: const Text(
              "****   ****   ****   ****",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),

          // Cardholder Name & Eye Icon
          Positioned(
            top: 110,
            left: 16,
            child: Row(
              children: [
                Text(
                  _fullName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                Icon(Icons.remove_red_eye, color: Colors.white, size: 18),
              ],
            ),
          ),

          // Valid Thru & CVV
          Positioned(
            bottom: 30,
            left: 16,
            child: const Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "VALID",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    Text(
                      "THUR",
                      style: TextStyle(
                          color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(width: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "0/00",
                      style: TextStyle(
                          color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "CVV",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // MasterCard Logo (Bottom Right)
          Positioned(
            bottom: 16,
            right: 16,
            child: Image.asset(
              "assets/mastercard.png", // Add your MasterCard logo
              width: 40,
            ),
          ),
        ],
      ),
    );
  }
}
