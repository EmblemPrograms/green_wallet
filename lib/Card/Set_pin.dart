import 'package:http/http.dart' as http;
import 'package:green_wallet/services/auth_service.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'NCard.dart';

class SetPin extends StatefulWidget {
  const SetPin({Key? key}) : super(key: key);

  @override
  State<SetPin> createState() => _SetPinState();
}

class _SetPinState extends State<SetPin> {
  String _fullName = "Loading..."; // ✅ Declare _fullName
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  bool isButtonActive = false;

  void _checkPinComplete() {
    setState(() {
      isButtonActive =
          _controllers.every((controller) => controller.text.isNotEmpty);
    });

    if (isButtonActive) {
      final pin = _controllers.map((c) => c.text).join();
    }
  }
  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _fullName =
          prefs.getString("full_name") ?? "User"; // ✅ Load name dynamically
    });
  }
  @override
  void initState() {
    super.initState();
    _loadUserName();
    for (var controller in _controllers) {
      controller.addListener(_checkPinComplete);
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onKeyPress(String value) {
    setState(() {
      if (value == 'backspace') {
        for (int i = 3; i >= 0; i--) {
          if (_controllers[i].text.isNotEmpty) {
            _controllers[i].clear();
            break;
          }
        }
      } else {
        for (int i = 0; i < 4; i++) {
          if (_controllers[i].text.isEmpty) {
            _controllers[i].text = value;
            break;
          }
        }
      }
    });
  }

  Future<void> _handlePinSubmission() async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Dialog(
        backgroundColor: Colors.transparent,
        child: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF3F2771),
          ),
        ),
      ),
    );

    // Simulate network delay and process
    await Future.delayed(const Duration(seconds: 2));

    // Save card status
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_card', true);
    await prefs.setString('_fullname', _fullName); // optional: save name

    // Close the loading dialog
    if (context.mounted) Navigator.of(context).pop();

    // Show success dialog
    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const CustomDialogWidget(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
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
              "Enter your PIN!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            // Subtitle
            const Text(
              "Enter a 4–digit code you use for transaction",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // PIN Input
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return SizedBox(
                  width: 50,
                  child: TextField(
                    obscureText: true,
                    controller: _controllers[index],
                    textAlign: TextAlign.center, // Prevent manual typing
                    maxLength: 1,
                    readOnly: true, // Prevent manual typing
                    style: const TextStyle(fontSize: 24),
                    decoration: InputDecoration(
                      counterText: "", // Hides the max length counter
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF3F2771)),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 120),

            // "Next" Button
            ElevatedButton(
              onPressed: isButtonActive ? _handlePinSubmission : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: isButtonActive
                    ? const Color(0xFF3F2771)
                    : Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                "Create Card Now",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),

            // Custom Numeric Keyboard
            Expanded(
              child: GridView.builder(
                itemCount: 12,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Number of columns
                  mainAxisSpacing: 8, // Vertical spacing
                  crossAxisSpacing: 10, // Horizontal spacing
                  childAspectRatio: 1.8, // Adjust size of each key
                ),
                itemBuilder: (context, index) {
                  String keyValue;
                  if (index < 9) {
                    keyValue = '${index + 1}';
                  } else if (index == 9) {
                    keyValue = '';
                  } else if (index == 10) {
                    keyValue = '0';
                  } else {
                    keyValue = 'backspace';
                  }

                  return GestureDetector(
                    onTap: keyValue.isEmpty
                        ? null
                        : () {
                      _onKeyPress(keyValue);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: keyValue == 'backspace'
                            ? Colors.grey[300]
                            : Colors.white,
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: keyValue == 'backspace'
                          ? const Icon(Icons.backspace_outlined, size: 24)
                          : Text(
                        keyValue,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDialogWidget extends StatelessWidget {
  const CustomDialogWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      if (context.mounted) {
        Navigator.of(context).pop(); // Close the dialog
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CardP()),
        );
      }
    });
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Ensure rounded corners
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 0),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
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
            const SizedBox(height: 0),
            // Title
            const Text(
              "Card Created Successfully",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // Subtitle
            const Text(
              "Please keep it safe and do not share it with anyone",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}