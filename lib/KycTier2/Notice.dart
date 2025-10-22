import 'package:flutter/material.dart';
import 'package:green_wallet/KycTier2/IDVerify.dart';
import 'package:green_wallet/KycTier2/Continue.dart';

class Notice extends StatefulWidget {
  const Notice({super.key});

  @override
  State<Notice> createState() => _NoticeState();
}

class _NoticeState extends State<Notice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () {
           Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Continue()));
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Notice, Release, and Acceptance of VidCapture Facial Scan Recording Policy and Terms of Service",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 10),
            Text(
              "1. Purpose of Collection:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "VidCapture may use facial scans solely for identity verification, personalized experiences, or improving our platform’s functionality. We do not sell or share your biometric data with third parties without your consent.",
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                height: 1.4,
              ),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 10),
            Text(
              "2. Consent",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "By using our platform, you consent to the collection and use of facial scans and other data as outlined in this policy. You have the right to withdraw consent by contacting our support team at any time.",
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                height: 1.4,
              ),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 10),
            Text(
              "3. Data",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "All biometric data, including facial scans, is securely encrypted and stored on compliant servers. We implement industry-standard security measures to protect your data.",
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                height: 1.4,
              ),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 10),
            Text(
              "4. Data Retention",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Facial scan data will only be retained for as long as necessary to fulfill its intended purpose or as required by law. Upon termination of your account, your data will be permanently deleted within 30 days.",
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                height: 1.4,
              ),
              textAlign: TextAlign.justify,
            ),
            Spacer(),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IDVerify(),
                        ),
                      );// Handle Accept button press
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3F2771),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: Text(
                      "Accept",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      // Handle Do Not Accept button press
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      side: BorderSide(color: const Color(0xFF3F2771)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: Text(
                      "Do not Accept",
                      style: TextStyle(
                        color: const Color(0xFF3F2771),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
