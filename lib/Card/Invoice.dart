import 'package:flutter/material.dart';
import 'package:green_wallet/Card/homepage.dart';
import 'package:green_wallet/widgets/Navigation_bar.dart';
import 'package:green_wallet/InoviceCreation/Create_invoice.dart';

import 'Profile.dart';
import 'NCard.dart';

class InvoiceP extends StatefulWidget {
  const InvoiceP({super.key});

  @override
  State<InvoiceP> createState() => _InvoicePState();
}

class _InvoicePState extends State<InvoiceP> {
  int _selectedIndex = 2;

  // List of screens (widgets) for navigation
  final List<Widget> _pages = [
    const HomepageScreen(),
    const MyCardsPage(),
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

class Invoice extends StatefulWidget {
  const Invoice({super.key});

  @override
  State<Invoice> createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(    );
  }
}
