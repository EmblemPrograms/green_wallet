import 'package:flutter/material.dart';
import 'package:green_wallet/KycTier2/IDVerify.dart';
import 'package:green_wallet/KycTier2/Setup_pin.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';


class TakePhoto extends StatefulWidget {
  const TakePhoto({super.key});

  @override
  State<TakePhoto> createState() => _TakePhotoState();
}

class _TakePhotoState extends State<TakePhoto> {
  File? _selectedFile;
  String? fileName; // Variable to hold the file name
  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        setState(() {
          _selectedFile = File(result.files.single.path!);
          fileName = result.files.single.name;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("📄 File selected: $fileName")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ No file selected. ")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ File selection error ")),
      );
    }
  }

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
                context, MaterialPageRoute(builder: (context) => IDVerify()));
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
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: _selectedFile != null
                  ? Image.file(
                _selectedFile!,
                width: 250,
                height: 250,
                fit: BoxFit.cover,
              )
                  : Image.asset(
                'assets/image17.png',
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
            ),

            Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFE0E0E0)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(fileName ?? "File Name",
                    style: TextStyle(
                      fontSize: 10,
                    ),),
                ],
              ),
            ),
            Spacer(),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final picker = ImagePicker();
                      final XFile? image =
                      await picker.pickImage(source: ImageSource.camera);

                      if (image != null) {
                        setState(() {
                          _selectedFile = File(image.path);
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
                      // Handle "Take a Photo" button action
                    },
                    icon: Icon(Icons.camera_alt_outlined, color: Colors.white),
                    label: Text(
                      "Take a Photo",
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
                      pickFile(); // Handle "Attach File" button action
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
                SizedBox(height: 12),
                TextButton(onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SetupPin()),
                  );
                },
                    child: Text("Next",)
                )
              ],
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
