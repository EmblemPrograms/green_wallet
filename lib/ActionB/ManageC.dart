import 'package:flutter/material.dart';

class ManageC extends StatefulWidget {
  const ManageC({super.key});

  @override
  State<ManageC> createState() => _ManageCState();
}

class _ManageCState extends State<ManageC> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Card",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: CircleAvatar(
              backgroundColor: Color(0xFF9378FF),
              child: IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  // Add card functionality
                },
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // Card UI
            _buildCardUI(),

            const SizedBox(height: 20),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(Icons.lock_outline, "Card Limits", () {
                  // Navigate to Card Limits
                }),
                _buildActionButton(Icons.ac_unit, "Freeze", () {
                  // Freeze card logic
                }),
                _buildActionButton(Icons.delete_outline, "Delete", () {
                  // Delete card logic
                }),
              ],
            ),

            const SizedBox(height: 100),

            // No Transactions Message
            _buildNoTransactions(),
          ],
        ),
      ),
    );
  }

  Widget _buildCardUI() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF3F2771),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/chip.png', // Replace with your chip icon asset
                width: 40,
              ),
              const Icon(Icons.visibility, color: Colors.white),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            "****  ****  ****  ****",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "ABDUL GAFAR",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "VALID THUR\n0/00",
                style: TextStyle(color: Colors.white),
              ),
              const Text(
                "CVV\n***",
                style: TextStyle(color: Colors.white),
              ),
              Image.asset(
                'assets/mastercard.png', // Replace with your card brand asset
                width: 50,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            radius: 30,
            child: Icon(icon, size: 30, color: Colors.black),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildNoTransactions() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white60,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            'assets/no_transactions.png', // Replace with your "no transactions" asset
            width: 50,
            height: 100, // Set your desired height
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 10),
          const Text(
            "No Transactions yet",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}