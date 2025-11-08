import 'package:flutter/material.dart';
import 'package:green_wallet/Card/homepage.dart';

class Topupd extends StatefulWidget {
  final double fundAmount;
  final double fundingFee;
  final String destination;
  const Topupd({super.key,
    required this.fundAmount,
    required this.fundingFee,
    required this.destination,});

  @override
  State<Topupd> createState() => _TopupdState();
}

class _TopupdState extends State<Topupd> {
  double get totalAmount => widget.fundAmount + widget.fundingFee;
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
        centerTitle: true,
        title: const Text(
          "Review Details",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Transaction Summary
            Text(
              "You are about to top up ₦${widget.fundAmount.toStringAsFixed(2)} to ${widget.destination}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

// Fund Amount Row
            _buildSummaryRow("Fund amount", "₦${widget.fundAmount.toStringAsFixed(2)}"),
            const SizedBox(height: 5),

// Funding Fee Row
            _buildSummaryRow("Funding fee", "₦${widget.fundingFee.toStringAsFixed(2)}"),
            const SizedBox(height: 5),

            // Total Amount Row
            _buildSummaryRow("Total amount", "₦${totalAmount.toStringAsFixed(2)}"),
            const SizedBox(height: 20),

            // Total Amount to Send (Highlighted)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFEDE7F6), // Light purple background
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Total Amount to send    ₦${totalAmount.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const Spacer(),

            // Confirm Button
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
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
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => CustomDialogWidget(),
                  );
                },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3F2771),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
                child: const Text(
                  "Confirm",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
      ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Helper method to build summary rows
  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class CustomDialogWidget extends StatelessWidget {
  const CustomDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      if (context.mounted) {
        Navigator.of(context).pop(); // Close the dialog
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeContainer()),
        );
      }
    });
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Ensure rounded corners
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 0),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success icon
            Image.asset(
              'assets/Done.png', // Ensure this path matches your file location
              height: 150,
              width: 150,
            ),
            SizedBox(height: 0),
            // Title
            Text(
              "Top Up Successful",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            // Subtitle
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}