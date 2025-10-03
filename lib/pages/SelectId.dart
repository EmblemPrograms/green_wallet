import 'package:flutter/material.dart';
import 'package:green_wallet/pages/Take_Photo.dart';
import 'package:green_wallet/pages/Notice.dart';

class Selectid extends StatefulWidget {
  const Selectid({super.key});

  @override
  State<Selectid> createState() => _SelectidState();
}

class _SelectidState extends State<Selectid> {
  String? selectedDocument; // Variable to track the selected document
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
                context, MaterialPageRoute(builder: (context) => Notice()));
          },
        ),
        title: Text(
          "Select Document",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildListTile("National Id Card"),
                  _buildListTile("Driver's Licence"),
                  _buildListTile("NIN Slip"),
                  _buildListTile("Voter’s Card"),
                  _buildListTile("International Passport"),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF442266), // Dark purple color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TakePhoto(),
                  ),
                ); // Handle continue button click
              },
              child: Text(
                "Continue",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(String documentName) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(
          documentName,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        trailing: Radio<String>(
          value: documentName,
          groupValue: selectedDocument,
          onChanged: (value) {
            setState(() {
              selectedDocument = value; // Update selected document
            });
          },
          activeColor: Color(0xFF3F2771), // Purple color for the radio button
        ),
      ),
    );
  }
}