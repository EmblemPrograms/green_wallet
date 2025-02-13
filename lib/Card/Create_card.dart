import 'package:flutter/material.dart';

import '../Card/select_pin.dart';

class CreateCard extends StatefulWidget {
  const CreateCard({super.key});

  @override
  State<CreateCard> createState() => _CreateCardState();
}

class _CreateCardState extends State<CreateCard> {
  String _selectedLabel = ""; // Track the currently selected button
  bool _isButtonEnabled = false; // Track if the submit button should be enabled

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // Title
            const Text(
              "Create Card",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),

            // Card Preview
            Center(
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE7F6), // Light purple card background
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  children: [
                    // Card Details
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "**** **** **** ****",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "ABDUL GAFAR",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                "VALID THRU  0/00",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                "CVV",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Mastercard Logo
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: Row(
                        children: const [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.orange,
                          ),
                          SizedBox(width: 0),
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Card Name Field
            const Text(
              "Name your Card",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: "Card name",
              ),
            ),
            const SizedBox(height: 10),

            // Suggestions
            const Text(
              "Can’t think of a name? Pick one below",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTextButton("Online Shopping"),
                _buildTextButton("House Party"),
                _buildTextButton("House Runs"),
              ],
            ),
            const SizedBox(height: 20),

            // Fund Card Field
            const Text(
              "Fund Card",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: "Fund card in dollars",
              ),
            ),
            const SizedBox(height: 40),

            // Submit Button (Initially Disabled)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isButtonEnabled
                    ? () {
                  // Action when button is enabled
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SelectPin()),
                  );
                }
                    : null, // Button disabled if no selection
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  _isButtonEnabled ? const Color(0xFF3F2771) : Colors.grey, // Active/Disabled color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  "Enter Transaction PIN to Create",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// **Text Button Widget**
  Widget _buildTextButton(String label) {
    final bool isSelected = _selectedLabel == label;
    return TextButton(
      onPressed: () {
        setState(() {
          _selectedLabel = label; // Update selected button
          _isButtonEnabled = true; // Enable the submit button
        });
      },
      style: TextButton.styleFrom(
        backgroundColor: isSelected
            ? const Color(0xFF3F2771) // Selected button color
            : const Color(0xFFEDE7F6), // Default button color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected
              ? Colors.white // Text color for the selected button
              : const Color(0xFF3F2771), // Text color for unselected button
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
