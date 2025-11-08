import 'dart:convert';
import 'Select_pin.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ChangePin extends StatefulWidget {
  const ChangePin({super.key});

  @override
  State<ChangePin> createState() => _ChangePinState();
}

class _ChangePinState extends State<ChangePin> {
  final List<TextEditingController> _controllers =
  List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  bool isButtonActive = false;
  bool _isLoading = false; // ✅ Add loading state

  void _checkPinComplete() {
    setState(() {
      isButtonActive =
          _controllers.every((controller) => controller.text.isNotEmpty);
    });
  }

  @override
  void initState() {
    super.initState();
    for (var controller in _controllers) {
      controller.addListener(_checkPinComplete);
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  Future<void> _savePin() async {
    if (!isButtonActive) return;

    final String oldPin = _controllers.map((c) => c.text).join();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("old_pin", oldPin);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SelectPin()),
    );
  }

  void _onKeyPress(String value) {
    setState(() {
      if (value == 'backspace') {
        for (int i = 3; i >= 0; i--) {
          if (_controllers[i].text.isNotEmpty) {
            _controllers[i].clear();
            _focusNodes[i].requestFocus();
            break;
          }
        }
      } else {
        for (int i = 0; i < 4; i++) {
          if (_controllers[i].text.isEmpty) {
            _controllers[i].text = value;
            if (i < 3) _focusNodes[i + 1].requestFocus();
            break;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(
              context,
            );
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
              "Enter Current PIN!",
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
              "Enter your current 4–digit code",
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
                    focusNode: _focusNodes[index],
                    textAlign: TextAlign.center,
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
            const SizedBox(height: 140),

            // "Next" Button
            ElevatedButton(
              onPressed: _isLoading ? null : _savePin, // ✅ Call API function
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor:
                isButtonActive ? const Color(0xFF3F2771) : Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Next",
                  style: TextStyle(fontSize: 16, color: Colors.white)),
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

