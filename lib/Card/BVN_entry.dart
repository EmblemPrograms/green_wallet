import 'package:flutter/material.dart';
import 'package:green_wallet/Card/Validate_card.dart';

class BvnEntry extends StatefulWidget {
  const BvnEntry({super.key});

  @override
  State<BvnEntry> createState() => _BvnEntryState();
}

class _BvnEntryState extends State<BvnEntry> {
  final TextEditingController _bvnController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();

    // Listen to changes in the text field
    _bvnController.addListener(_handleTextChanged);
  }

  @override
  void dispose() {
    _bvnController.removeListener(_handleTextChanged);
    _bvnController.dispose();
    super.dispose();
  }

  void _handleTextChanged() {
    setState(() {
      _isButtonEnabled = _bvnController.text.length == 11;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Title
            const Text(
              "Enter your BVN",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),

            // Subtitle
            const Text(
              "To comply with legal requirements, we kindly request your Bank Verification Number (BVN)",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 30),

            // BVN Input Field
            TextField(
              controller: _bvnController,
              decoration: InputDecoration(
                hintText: "Enter your BVN",
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                counterText: "", // Removes the counter below the field
              ),
              keyboardType: TextInputType.number,
              maxLength: 11, // Enforces a maximum length of 11
            ),
            const Spacer(),

            // Create Virtual Card Button
            ElevatedButton(
              onPressed: _isButtonEnabled
                  ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ValidateCard()),
                );
              }
                  : null, // Disable the button if BVN is invalid
              style: ElevatedButton.styleFrom(
                backgroundColor: _isButtonEnabled
                    ? const Color(0xFF3F2771) // Purple when enabled
                    : Colors.grey, // Grey when disabled
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                minimumSize: const Size(double.infinity, 50), // Full-width button
              ),
              child: const Text(
                "Create Virtual Card",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
