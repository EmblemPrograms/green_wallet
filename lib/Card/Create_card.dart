import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Card/select_pin.dart';
import 'Set_pin.dart';

class CreateCard extends StatefulWidget {
  const CreateCard({super.key});

  @override
  State<CreateCard> createState() => _CreateCardState();
}

class _CreateCardState extends State<CreateCard> {
  String _fullName = "Loading...";
  bool _isButtonEnabled = false;
  bool _isLoading = false;
  String? _selectedCardType;
  String? _selectedCardBrand;
  String? _selectedCurrency;

  final TextEditingController _cardNameController = TextEditingController(); // Not currently used for input but can be for state
  final TextEditingController _cardLimitController = TextEditingController();
  final TextEditingController _initialAmountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    _loadUserName();
  }
  void _checkButtonEnabled() {
    setState(() {
      _isButtonEnabled = _selectedCardType != null &&
          _selectedCardBrand != null &&
          _selectedCurrency != null &&
          _cardLimitController.text.isNotEmpty &&
          _initialAmountController.text.isNotEmpty;
    });
  }


  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _fullName = prefs.getString("full_name") ?? "User";
    });
  }

  Future<void> _saveCardData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('card_type', _selectedCardType ?? '');
    await prefs.setString('card_brand', _selectedCardBrand ?? '');
    await prefs.setString('currency', _selectedCurrency ?? '');
    await prefs.setString('card_limit', '\$${_cardLimitController.text}');
    await prefs.setDouble('initial_amount', double.tryParse(_initialAmountController.text) ?? 0);
  }

  void _goToSetPin() async {
    await _saveCardData();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SetPin()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon:
          const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                const Text(
                  "Create Card",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),

                // Card Preview
                Center(
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3F2771),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
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
                          Text(
                            _fullName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "VALID THRU  ${DateTime.now().month.toString().padLeft(2, '0')}/${(DateTime.now().year + 4) % 100}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text("CVV", style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                const Text("Card Type",
                    style:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                DropdownButtonFormField<String>(
                  value: _selectedCardType,
                  items: ["virtual"]
                      .map((label) => DropdownMenuItem(
                            child: Text(label),
                            value: label,
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCardType = value;
                      if (value != null) {
                        _cardNameController.text = value;
                        _isButtonEnabled = true; // Or based on other fields as well
                      } else {
                        _isButtonEnabled = false;
                      }
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    hintText: "Select Card Type",
                  ),
                  validator: (value) =>
                      value == null ? 'Please select a card type' : null,
                ),
                const SizedBox(height: 10),
                const Text("Card Brand",
                    style:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                DropdownButtonFormField<String>(
                  value: _selectedCardBrand,
                  items: ["Mastercard"]
                      .map((label) => DropdownMenuItem(
                            child: Text(label),
                            value: label,
                          ))
                      .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCardBrand = value;
                      });
                      _checkButtonEnabled();
                    },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    hintText: "Select Card Brand",
                  ),
                  validator: (value) =>
                      value == null ? 'Please select a card brand' : null,
                ),

                const SizedBox(height: 10),
                const Text("Card Limit",
                    style:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
        TextFormField(
            controller: _cardLimitController,
            keyboardType: TextInputType.number,
            onChanged: (_) => _checkButtonEnabled(),
        decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    hintText: "e.g., 5000.00",
                  ),
                ),
                const SizedBox(height: 10),
                const Text("Currency",
                    style:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                DropdownButtonFormField<String>(
                  value: _selectedCurrency,
                  items: ["USD"]
                      .map((label) => DropdownMenuItem(
                            child: Text(label),
                            value: label,
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCurrency = value;
                    });
                    _checkButtonEnabled();
                  },

                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    hintText: "Select Currency",
                  ),
                  validator: (value) => value == null ? 'Please select a currency' : null,
                ),
                const SizedBox(height: 10),
                const Text("Initial Amount",
                    style:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
        TextFormField(
            controller: _initialAmountController,
            keyboardType: TextInputType.number,
            onChanged: (_) => _checkButtonEnabled(),
        decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    hintText: "e.g., 1000.00",
                  ),
                ),
                const SizedBox(height: 20),

                // Submit Button
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: _isButtonEnabled ? const Color(0xFF3F2771) : Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: _isButtonEnabled
                        ? [
                      BoxShadow(
                        color: const Color(0xFF3F2771).withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                        : [],
                  ),
                  child: MaterialButton(
                    onPressed: _isButtonEnabled
                        ? _goToSetPin
                        : null,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    child: Text(
                      "Enter Transaction PIN to Create",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                // Added space after button
                const SizedBox(height: 30),
              ],
            ),
          ),

          // Loading overlay
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.4),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

}
