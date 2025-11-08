import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/auth_service.dart';
import '../Card/homepage.dart';
import 'Setup_pin.dart';

class Selfie extends StatefulWidget {
  const Selfie({super.key});

  @override
  State<Selfie> createState() => _SelfieState();
}

class _SelfieState extends State<Selfie> {
  File? _selfieImage;
  String? fileName; // To store the captured selfie
  final picker = ImagePicker();

  // Method to open the camera and take a selfie
  Future<void> takeSelfie() async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        setState(() {
          _selfieImage = File(image.path);
          fileName = image.name;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("📷 Selfie captured: ${image.name}")),
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

  Future<void> _submitAllData() async {
    if (_selfieImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Please take a selfie first")),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final storedData = prefs.getString('kyc_tier2_data');
    if (storedData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ No saved KYC data found.")),
      );
      return;
    }

    final Map<String, dynamic> kycData = jsonDecode(storedData);
    String selfieBase64 = base64Encode(await _selfieImage!.readAsBytes());
    kycData['selfie'] = selfieBase64;

    final token = await AuthService.getToken();
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Please log in again.")),
      );
      return;
    }

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF442266)),
      ),
    );

    try {
      final uri = Uri.parse(
        "https://greenwallet-6a1m.onrender.com/api/users/users/kyc/verify-tier2?token=$token",
      );

      var request = http.MultipartRequest('POST', uri);

      request.fields['bvn'] = kycData['bvn'];
      request.fields['document_type'] = kycData['document_type'];
      request.fields['date_of_birth'] = kycData['date_of_birth'];
      request.fields['gender'] = kycData['gender'];

      // Reattach files from base64
      final frontBytes = base64Decode(kycData['front_image']);
      final frontFile = File('${Directory.systemTemp.path}/front.jpg');
      await frontFile.writeAsBytes(frontBytes);
      request.files
          .add(await http.MultipartFile.fromPath('front', frontFile.path));

      if (kycData['back_image'] != null) {
        final backBytes = base64Decode(kycData['back_image']);
        final backFile = File('${Directory.systemTemp.path}/back.jpg');
        await backFile.writeAsBytes(backBytes);
        request.files
            .add(await http.MultipartFile.fromPath('back', backFile.path));
      }

      // Add selfie
      final selfieFile = File('${Directory.systemTemp.path}/selfie.jpg');
      await selfieFile.writeAsBytes(base64Decode(kycData['selfie']));
      request.files
          .add(await http.MultipartFile.fromPath('selfie', selfieFile.path));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      Navigator.pop(context);

      if (response.statusCode == 200) {
        await prefs.remove('kyc_tier2_data');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ KYC Verification Successful")),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Create Your Pin")),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const SetupPin()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Verification failed: ${response.body}")),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Error submitting KYC: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
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
            const SizedBox(height: 10),

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
            const SizedBox(height: 5),

            // Subtitle
            const Text(
              "We need to take your picture to verify your identity",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Circular Image with Border
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3F2771),
                    shape: BoxShape.circle,
                  ),
                ),
                ClipOval(
                  child: _selfieImage == null
                      ? Image.asset(
                          'assets/photo.png', // Placeholder image asset
                          height: 250,
                          width: 250,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          _selfieImage!,
                          height: 250,
                          width: 250,
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
            const SizedBox(height: 30),

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
            SizedBox(height: 8),
            TextButton(
              onPressed: () {
                takeSelfie();
              },
              child: Text("Take Selfie",
                  style: TextStyle(
                    color: Color(0xFF3F2771),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )),
            ),

            const Spacer(),

            // Continue Button
            ElevatedButton(
              onPressed: _submitAllData,

              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: const Color(0xFF3F2771),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                "Submit",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 40),
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
          const SizedBox(width: 8),
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
