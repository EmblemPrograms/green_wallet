import 'package:flutter/material.dart';
import 'package:green_wallet/Card/homepage.dart';
import 'package:intl/intl.dart';

class CardLimits extends StatefulWidget {
  const CardLimits({super.key});

  @override
  State<CardLimits> createState() => _CardLimitsState();
}

class _CardLimitsState extends State<CardLimits> {
  double _currentLimit = 50000; // Default slider value
  final double _maxLimit = 1000000; // Maximum limit
  final NumberFormat currencyFormat = NumberFormat.currency(locale: 'en_NG', symbol: '₦'); // Formatting

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Card Limits",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              "Daily Limit",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 10),
            Text(
              currencyFormat.format(_currentLimit),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3D1B6F), // Dark purple color
              ),
            ),
            SizedBox(height: 10),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 5,
                activeTrackColor: Color(0xFF3D1B6F),
                inactiveTrackColor: Colors.purple[100],
                thumbColor: Color(0xFF3D1B6F),
                overlayColor: Color(0xFF3D1B6F).withOpacity(0.2),
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12),
              ),
              child: Slider(
                value: _currentLimit,
                min: 10000,
                max: _maxLimit,
                divisions: 10,
                onChanged: (value) {
                  setState(() {
                    _currentLimit = value;
                  });
                },
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Adjust the slider to set your preferred limit per transaction online",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Daily Limit",
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                Text(
                  currencyFormat.format(1000000), // ₦1,000,000.00
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Monthly Limit",
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                Text(
                  currencyFormat.format(4000000), // ₦4,000,000.00
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3D1B6F),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Limit updated successfully!"),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeContainer()),
                );
              },
              child: Text(
                "Save",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}