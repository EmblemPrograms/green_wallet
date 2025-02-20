import 'package:flutter/material.dart';
import 'package:green_wallet/pages/SelectId.dart';
import 'package:green_wallet/pages/Setup_pin.dart';

class TakePhoto extends StatefulWidget {
  const TakePhoto({super.key});

  @override
  State<TakePhoto> createState() => _TakePhotoState();
}

class _TakePhotoState extends State<TakePhoto> {
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
                  context, MaterialPageRoute(builder: (context) => Selectid()));
          },
        ),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              "International Passport",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Nigeria",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Image.asset(
              'assets/image17.png', // Replace with the correct path to your image
              width: 200,
              height: 200,
              fit: BoxFit.contain, // Ensures the image fits within the size constraints
            ),
            Spacer(),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => SetupPin()));
                      // Handle "Take a Photo" button action
                    },
                    icon: Icon(Icons.camera_alt_outlined, color: Colors.white),
                    label: Text("Take a Photo",
                      style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF442266),
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Handle "Attach File" button action
                    },
                    icon: Icon(Icons.attach_file, color: Color(0xFF442266)),
                    label: Text(
                      "Attach File",
                      style: TextStyle(
                        color: Color(0xFF442266),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      side: BorderSide(color: Color(0xFF442266)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}