import 'package:flutter/material.dart';
import 'package:green_wallet/Card/homepage.dart';
import 'package:green_wallet/KycTier2/Continue.dart';


class NoticeId extends StatefulWidget {
  const NoticeId({super.key});

  @override
  State<NoticeId> createState() => _NoticeIdState();
}

class _NoticeIdState extends State<NoticeId> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3F2771),
      appBar: AppBar(
          backgroundColor: const Color(0xFF3F2771),
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeContainer()));
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                "Almost there!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Verify your identity to get your foreign account",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "We’re required by law to verify your identity before you can begin making transactions on GreenWallet.",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 16,
                  height: 2.0,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "The next step will require you to take a a visible image of yourself",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 16,
                  height: 2.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 160,),
              // Next button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Continue(),
                      ),
                    );// Next button functionality
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Color(0xFF3F2771), backgroundColor: Colors.white, // Purple text color
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    "Next",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}