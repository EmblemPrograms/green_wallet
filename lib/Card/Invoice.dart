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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeContainer()),);
          },
        ),
        title: const Text(
          "Invoice",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),

            // Illustration Image
            Image.asset(
              "assets/invoice.png", // Replace with the correct image path
              height: 300,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 30),

            // Title
            const Text(
              "Manage your invoice",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),

            // Subtitle
            const Text(
              "Create, send and manage payment invoices here",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 80),

            // "Create Invoice" Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateInvoice()),);// Handle invoice creation
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F2771), // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  "Create Invoice",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
