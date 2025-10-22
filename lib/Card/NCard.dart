import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:green_wallet/widgets/Navigation_bar.dart';
import 'package:green_wallet/Card/homepage.dart';
import '../services/auth_service.dart';
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
  bool _isLoading = true;
  bool _hasCard = false;
  String? _errorMessage;
  @override
  void initState() {
    super.initState();
    _checkCardExistence(); // 👈 replaced fetchUserProfile()
  }

  Future<void> _checkCardExistence() async {
    try {
      setState(() => _isLoading = true);

      // 🟩 Get stored user profile
      final profile = await AuthService.getUserProfile();

      // Try to read virtual cards (if you decide to store them)
      // OR just check if card_id is not empty
      final String? cardId = profile['card_id'];

      setState(() {
        _hasCard = cardId != null && cardId.isNotEmpty;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to check card status: $e";
        _isLoading = false;
      });
    }
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    // Dynamically build the list of pages based on card status
    final List<Widget> pages = [
      const HomepageScreen(),
      _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF3F2771)))
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)))
          : _hasCard
          ? const VCard()
          : const NCard(),
      const Invoice(),
      const Profile(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        // Ensure that if loading, an index within bounds is used, or show a loader
        // However, with the current logic, pages are always populated.
        selectedIndex: _selectedIndex < pages.length ? _selectedIndex : 0,
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
  String _fullName = "User";
  String? _cardNumber;
  String? _cvv;
  String? _expiry;
  bool _isCardDetailsVisible = false;
  bool _isLoading = true;
  String? _errorMessage;



  String _formatCardNumber(String? cardNumber) {
    if (cardNumber == null) return "**** **** **** ****";
    if (!_isCardDetailsVisible) return "**** **** **** ${cardNumber.substring(cardNumber.length - 4)}";
    return cardNumber.replaceAllMapped(RegExp(r'.{4}'), (match) => '${match.group(0)} ').trim();
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
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF3F2771)))
            : _errorMessage != null
            ? Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)))
            : _buildVirtualCard(),
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
          // GreenWallet logo
          Positioned(
            top: 16,
            right: 16,
            child: Image.asset("assets/gw21.png", width: 90),
          ),
          // Card Chip
          Positioned(
            top: 20,
            left: 16,
            child: Image.asset("assets/chip.png", width: 40),
          ),
          // Card Number
          Positioned(
            top: 70,
            left: 16,
            child: Text(
              _formatCardNumber(_cardNumber),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
          // Cardholder Name and Eye Icon
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
                GestureDetector(
                  onTap: () => setState(() => _isCardDetailsVisible = !_isCardDetailsVisible),
                  child: Icon(
                    _isCardDetailsVisible ? Icons.visibility_off : Icons.remove_red_eye,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
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
                    const Text(
                      "VALID",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        letterSpacing: 1.5,
                        fontFamily: 'Courier',
                      ),
                    ),
                    Text(
                      "THRU",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        fontFamily: 'Courier',
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _expiry ?? "${DateTime.now().month.toString().padLeft(2, '0')}/${(DateTime.now().year + 3) % 100}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        fontFamily: 'Courier',
                      ),
                    ),
                    Text(
                      _isCardDetailsVisible ? (_cvv ?? "CVV") : "CVV",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        letterSpacing: 1.5,
                        fontFamily: 'Courier',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // MasterCard Logo
          Positioned(
            bottom: 16,
            right: 16,
            child: Image.asset("assets/mastercard.png", width: 40),
          ),
        ],
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