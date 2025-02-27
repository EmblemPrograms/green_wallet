import 'package:flutter/material.dart';
import 'package:green_wallet/ActionB/ReviewD.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Convert extends StatefulWidget {
  const Convert({super.key});

  @override
  State<Convert> createState() => _ConvertState();
}

class _ConvertState extends State<Convert> {
  final TextEditingController _ngnController = TextEditingController();
  double _usdAmount = 0.0;
  double _exchangeRate = 1660.0; // Default exchange rate
  bool _isNextEnabled = false;
  bool _isLoading = true; // Loading state for exchange rate

  @override
  void initState() {
    super.initState();
    _fetchExchangeRate();
    _ngnController.addListener(_updateUsdAmount);
  }

  Future<void> _fetchExchangeRate() async {
    const String apiKey =
        "256793736a60aaa5c15d2df9"; // Replace with a real API key
    const String url = "https://v6.exchangerate-api.com/v6/$apiKey/latest/USD";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _exchangeRate =
              data["conversion_rates"]["NGN"] ?? 1660.0; // Update exchange rate
          _isLoading = false;
        });
      } else {
        print("Failed to fetch exchange rate");
      }
    } catch (e) {
      print("Error fetching exchange rate: $e");
    }
  }

  void _updateUsdAmount() {
    setState(() {
      String input = _ngnController.text;
      if (input.isNotEmpty) {
        double? ngnValue = double.tryParse(input);
        if (ngnValue != null && ngnValue > 0) {
          _usdAmount = ngnValue / _exchangeRate;
          _isNextEnabled = true;
        } else {
          _usdAmount = 0.0;
          _isNextEnabled = false;
        }
      } else {
        _usdAmount = 0.0;
        _isNextEnabled = false;
      }
    });
  }

  void _goToReviewPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewD(
          ngnAmount: _ngnController.text,
          usdAmount: _usdAmount.toStringAsFixed(2),
          exchangeRate: _exchangeRate,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ngnController.dispose();
    super.dispose();
  }

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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Convert your Money",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              "Select currencies to convert",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // NGN Input (User Enters Amount)
            _buildCurrencyInput(
                "NGN", "Nigerian Naira", "assets/ngn_flag.png", _ngnController,
                isEditable: true),

            // Exchange Rate Badge
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildExchangeRateBadge(
                    "1 USD = ${_exchangeRate.toStringAsFixed(2)} NGN"),
            SizedBox(height: 10),
            // USD Input (Auto Calculated)
            _buildCurrencyInput(
                "USD", "United States Dollar", "assets/us_flag.png", null,
                isEditable: false),

            const Spacer(),

            // Next Button
            _buildNextButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyInput(String currency, String country, String asset,
      TextEditingController? controller,
      {required bool isEditable}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Image.asset(asset, width: 30, height: 30),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(currency,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              Text(country,
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: 120,
            child: isEditable
                ? TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Enter Amount",
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(fontSize: 14),
                  )
                : Text(
                    _usdAmount
                        .toStringAsFixed(2), // Display converted USD amount
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildExchangeRateBadge(String rate) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          rate,
          style: const TextStyle(fontSize: 14, color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return GestureDetector(
      onTap: _isNextEnabled ? _goToReviewPage : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: _isNextEnabled ? Color(0xFF3F2771) : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            "Next",
            style: TextStyle(
              color: _isNextEnabled ? Colors.white : Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
