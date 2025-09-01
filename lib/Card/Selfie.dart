import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'Create_card.dart';

class Selfie extends StatefulWidget {
  const Selfie({super.key});

  @override
  State<Selfie> createState() => _SelfieState();
}

class _SelfieState extends State<Selfie> {
  File? _selfieImage;
  String? fileName;// To store the captured selfie
  final picker = ImagePicker();

  // Method to open the camera and take a selfie
  Future<void> takeSelfie() async {
    try {
      final picker = ImagePicker();
      final XFile? image =
      await picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        setState(() {
          _selfieImage = File(image.path);
          fileName = image.name;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
              Text("📷 Selfie captured: ${image.name}")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ No image captured.")),
        );
      }
    } catch (e) {
      // Handle any errors (like permissions denied)
      print("Error opening camera: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // Title
            const Text(
              "Verify Your Identity",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Subtitle
            const Text(
              "We need to take your picture to verify your identity",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Circular Image with Border
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3F2771),
                    shape: BoxShape.circle,
                  ),
                ),
                ClipOval(
                  child: _selfieImage == null
                      ? Image.asset(
                    'assets/photo.png', // Placeholder image asset
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  )
                      : Image.file(
                    _selfieImage!,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                ),

                // Camera overlay icons
                Positioned(
                  top: -10,
                  left: -10,
                  child: Icon(Icons.crop_square_outlined,
                      size: 32, color: Colors.deepPurple),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Instruction List
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                InstructionItem(text: "Make sure there's good lighting"),
                InstructionItem(text: "Make sure you're not wearing glasses"),
                InstructionItem(
                    text: "Make sure your face is inside the frame"),
              ],
            ),

            const Spacer(),

            // Continue Button
            ElevatedButton(
              onPressed: () {
                takeSelfie();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: const Color(0xFF3F2771),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                "Continue",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 5),
            TextButton(onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => CreateCard()),
              );
            },
                child: Text("Next",)
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

// InstructionItem Widget for cleaner code
class InstructionItem extends StatelessWidget {
  final String text;

  const InstructionItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 8, color: Colors.deepPurple),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
