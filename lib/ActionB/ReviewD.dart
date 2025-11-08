import 'package:flutter/material.dart';
import 'package:green_wallet/Card/homepage.dart';


class ReviewD extends StatefulWidget {
  final String ngnAmount;
  final String usdAmount;
  final double exchangeRate;
  const ReviewD({super.key, required this.ngnAmount, required this.usdAmount, required this.exchangeRate});

  @override
  State<ReviewD> createState() => _ReviewDState();
}

class _ReviewDState extends State<ReviewD> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Review Details",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "Confirm details of your transaction.",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),
        
              // Exchange Rate Box
              Container(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF3F2771), // Dark purple
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _currencyInfo("🇳🇬", "₦${widget.ngnAmount}"), // Updated
                    const Icon(Icons.swap_horiz, color: Colors.white, size: 24),
                    _currencyInfo("🇺🇸", "\$${widget.usdAmount}"), // Updated
                  ],
                ),
              ),
              const SizedBox(height: 20),
        
              // Transaction Details Table
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    _transactionRow("From", "₦${widget.ngnAmount} (Naira)"), // Updated
                    _divider(),
                    _transactionRow("To", "\$${widget.usdAmount} (US Dollar)"), // Updated
                    _divider(),
                    _transactionRow("Exchange Rate", "1 USD = ${widget.exchangeRate.toStringAsFixed(2)} NGN"), // Updated
                    _divider(),
                    _transactionRow("Type", "Currency Conversion"),
                  ],
                ),
              ),
              const SizedBox(height: 20),
        
              // Total Amount
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Amount",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "₦${widget.ngnAmount}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 150,),
        
              // Convert Money Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3F2771),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return Dialog(
                          backgroundColor: Colors.transparent,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF3F2771),
                            ),
                          ),
                        );
                      },
                    );
        
                    // Simulate loading
                    await Future.delayed(Duration(seconds: 2));
                    Navigator.of(context).pop(); // Close the loading dialog
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeContainer(), // Pass USD amount
                      ),
                    );
                  },
                  child: const Text(
                    "Convert Money",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _currencyInfo(String flag, String amount) {
    return Row(
      children: [
        Text(flag, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 8),
        Text(
          amount,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ],
    );
  }

  Widget _transactionRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(color: Colors.grey.shade300, thickness: 1);
  }
}