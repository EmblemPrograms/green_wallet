import 'package:flutter/material.dart';
import 'package:green_wallet/KycTier2/Setup_pin.dart';
import 'package:green_wallet/Card/homepage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SelectPin extends StatefulWidget {
  const SelectPin({super.key});

  @override
  State<SelectPin> createState() => _SelectPinState();
}

class _SelectPinState extends State<SelectPin> {
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
    if (!isButtonActive) return; // Prevents clicking when PIN is incomplete

    setState(() {
      _isLoading = true;
    });

    final String pin =
        _controllers.map((c) => c.text).join(); // Combine PIN digits

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("auth_token");

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Authentication error. ")),
        );
        return;
      }
      // 🔹 STEP 1: Set user PIN
      final String apiUrl =
          "https://greenwallet-6a1m.onrender.com/api/users/users/pin/set?token=$token";

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"pin": pin}),
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String fullName = data['user']['full_name'] ?? "User";
        await prefs.setString("full_name", fullName);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? "PIN set successfully!")),
        );
// 🔹 STEP 2: Show temporary loading dialog
        showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return Dialog(
                  backgroundColor: Colors.transparent,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF3F2771),
                    ),
                  ),
                );
              },
            );
        // 🔹 STEP 3: Create deposit account automatically
        await _createDepositAccount(token);

        // 🔹 STEP 4: Close loading dialog and show success
        if (mounted) {
          Navigator.of(context).pop(); // Close loading spinner
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const CustomDialogWidget(),
          );
        }
      } else {
        print("❌ Server Error: ${response.statusCode}");
        print("❌ Response Body: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${response.statusCode}, ${response.body}")),
        );
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print("❌ Network Error: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Network error, try again!")),
      );
    }
  }

  Future<void> _createDepositAccount(String token) async {
    final String url =
        'https://greenwallet-6a1m.onrender.com/api/transactions/accounts?token=$token';

    final Map<String, dynamic> body = {
      "account_type": "Savings",
      "currency": "NGN",
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("✅ Deposit account created successfully!");
        print("Account Name: ${data['attributes']['accountName']}");
        print("Account Number: ${data['attributes']['accountNumber']}");

        // Optionally store account info in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("account_number", data['attributes']['accountNumber']);
        await prefs.setString("account_name", data['attributes']['accountName']);
      } else {
        print("❌ Deposit account creation failed: ${response.body}");
      }
    } catch (e) {
      print("❌ Error creating deposit account: $e");
    }
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SetupPin()),
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
              "Set up your PIN!",
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
              "Enter a 4–digit code you won’t forget",
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

class CustomDialogWidget extends StatelessWidget {
  const CustomDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      if (context.mounted) {
        Navigator.of(context).pop(); // Close the dialog
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => HomeContainer()), // Pass required parameter
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
              "PIN Created Successfully",
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
              "Please keep it safe and do not share it with anyone",
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
