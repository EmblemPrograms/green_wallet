import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:green_wallet/widgets/Navigation_bar.dart';
import 'package:green_wallet/Card/hompage.dart';
import 'Create_card.dart';
import 'Invoice.dart';
import 'Profile.dart';

class CardP extends StatefulWidget {
  const CardP({super.key});

  @override
  State<CardP> createState() => _CardPState();
}

class _CardPState extends State<CardP> {
  int _selectedIndex = 1;
  bool _hasCard = false;

  @override
  void initState() {
    super.initState();
    _checkIfCardExists();
  }

  Future<void> _checkIfCardExists() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _hasCard = prefs.getBool('has_card') ?? false;
    });
  }

  // List of screens (widgets) for navigation is built dynamically in build method.
  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const homepage(),
      _hasCard ? const VCard() : const NCard(),
      const Invoice(),
      const Profile(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onNavItemTapped,
      ),
    );
  }
}

class NCard extends StatefulWidget {
  const NCard({super.key});

  @override
  State<NCard> createState() => _NCardState();
}

class _NCardState extends State<NCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: const Text('My Virtual Card')),
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        height: 210,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFF3F2771), Color(0xFF6A47A3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.credit_card, color: Colors.white70, size: 28),
                Icon(Icons.add_card_outlined, color: Colors.white70, size: 28),
              ],
            ),
            const Spacer(),
            Center(
              child: Column(
                children: [
                  Text(
                    "No Card Yet",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "Tap below to create your GreenWallet card",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CreateCard()),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Create Card"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF3F2771),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                "VALID THRU  ${DateTime.now().month.toString().padLeft(2, '0')}/${(DateTime.now().year + 3) % 100}",
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                  letterSpacing: 1.5,
                  fontFamily: 'Courier',
                ),
              ),
            ),
          ],
        ),
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
  String _fullName = "_fullname"; // default if not found

  @override
  void initState() {
    super.initState();
    _loadCardOwner();
  }

  Future<void> _loadCardOwner() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fullName = prefs.getString("full_name") ?? "User"; // ✅ Load name dynamically
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: const Text('My Virtual Card')),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 40.0, right: 20.0, left: 20.0),
        child: _buildVirtualCard(),
      ),
    );
  }

  Widget _buildVirtualCard() {
    return Container(
      width: double.infinity,
      height: 210,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage("assets/gw1 2.png"),
          fit: BoxFit.scaleDown,
        ),
        color: const Color(0xFF3F2771),
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
            child: Image.asset(
              "assets/gw21.png",
              width: 90,
            ),
          ),

          // Card Chip
          Positioned(
            top: 20,
            left: 16,
            child: Image.asset(
              "assets/chip.png",
              width: 40,
            ),
          ),

          // Card Number (Masked)
          const Positioned(
            top: 70,
            left: 16,
            child: Text(
              "****   ****   ****   ****",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),

          // Cardholder Name
          Positioned(
            top: 110,
            left: 16,
            child: Row(
              children: [
                Text(
                  _fullName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.remove_red_eye, color: Colors.white, size: 18),
              ],
            ),
          ),

          // Valid Thru & CVV
          Positioned(
            bottom: 30,
            left: 16,
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("VALID", style: TextStyle(color: Colors.white70, fontSize: 12,
                      letterSpacing: 1.5,
                      fontFamily: 'Courier',)),
                    Text(
                      "THRU",
                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        fontFamily: 'Courier',),
                    ),
                  ],
                ),
                SizedBox(width: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${DateTime.now().month.toString().padLeft(2, '0')}/${(DateTime.now().year + 3) % 100}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        fontFamily: 'Courier',
                      ),
                    ),
                    Text("CVV", style: TextStyle(color: Colors.white70, fontSize: 12,
                      letterSpacing: 1.5,
                      fontFamily: 'Courier',)),
                  ],
                ),
              ],
            ),
          ),

          // MasterCard Logo
          Positioned(
            bottom: 16,
            right: 16,
            child: Image.asset(
              "assets/mastercard.png",
              width: 40,
            ),
          ),
        ],
      ),
    );
  }

}
