import 'package:flutter/material.dart';

import '../Card/homepage.dart';

class ReviewNgn extends StatefulWidget {
  const ReviewNgn({super.key});

  @override
  State<ReviewNgn> createState() => _ReviewNgnState();
}

class _ReviewNgnState extends State<ReviewNgn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Review Details",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              "You are about to Send ₦100.00 to Abdul Gafar",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[100],
              ),
              child: Column(
                children: [
                  _buildAmountRow("Fund amount", "₦100.00"),
                  _buildAmountRow("Transfer fee", "₦10.00"),
                  _buildAmountRow("Total amount", "₦110.00"),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Amount to send",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "₦110.00",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Spacer(),
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
                  );// Add confirmation logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3F2771),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  "Confirm",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountRow(String label, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
          Text(amount, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
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
              "Transfer Successful",
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