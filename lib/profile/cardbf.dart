import 'package:flutter/material.dart';
import 'package:green_wallet/widgets/Navigation_bar.dart';
import 'package:green_wallet/Card/NCard.dart';
import 'package:green_wallet/Card/Profile.dart';
import 'package:green_wallet/Card/homepage.dart';

import '../Card/Transfer.dart';
import 'addb.dart';

class CardsBeneficiariesPage extends StatefulWidget {
  const CardsBeneficiariesPage({super.key});

  @override
  State<CardsBeneficiariesPage> createState() => _CardsBeneficiariesPageState();
}

class _CardsBeneficiariesPageState extends State<CardsBeneficiariesPage> {
  int _selectedIndex = 4;

  // List of screens (widgets) for navigation
  final List<Widget> _pages = [
    const HomepageScreen(),
    const MyCardsPage(),
    const Transfer(),
    const Profile(),
    const Cardse(),
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

class Cardse extends StatefulWidget {
  const Cardse({super.key});

  @override
  State<Cardse> createState() => _CardseState();
}

class _CardseState extends State<Cardse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title: const Text(
            'Cards & Beneficiaries',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'No beneficiary added yet',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Tap the button below to add beneficiary',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddBeneficiary()),
                    );// Navigate to Add Beneficiary page or dialog
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.add, color: Color(0xFF3F2771)),
                      SizedBox(width: 6),
                      Text(
                        'Add New Beneficiary',
                        style: TextStyle(
                          color: Color(0xFF3F2771),
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
