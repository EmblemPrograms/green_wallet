import 'package:flutter/material.dart';
import 'package:green_wallet/KycTier1/BVN_entry.dart';

class CustomDialogWidget extends StatelessWidget {
  const CustomDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      if (context.mounted) {
        Navigator.of(context).pop(); // Close the dialog
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => BvnEntry()), // Pass required parameter
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
              "Profile Created Successfully",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
// Subtitle
            Text(
              "Verify your BVN to gain Access!",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
