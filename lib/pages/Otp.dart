import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:green_wallet/pages/Startup.dart';
import 'package:http/http.dart' as http;
import 'package:green_wallet/pages/AccountSetup.dart';
import 'package:green_wallet/widgets/textborder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Otp extends StatefulWidget {
  final String email; // Ensure this is present

  const Otp({super.key, required this.email});

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  int secondsRemaining = 59;
  late Timer timer;
  bool invalidOtp = false;
  bool _isLoading = false;
  bool isButtonActive = false;

  final List<TextEditingController> _otpControllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  void _checkOTPComplete() {
    setState(() {
      isButtonActive =
          _otpControllers.every((controller) => controller.text.isNotEmpty);
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
    for (var controller in _otpControllers) {
      controller.addListener(_checkOTPComplete);
    }
  }

  @override
  void dispose() {
    timer.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _onKeyPress(String value) {
    setState(() {
      if (value == 'backspace') {
        for (int i = 3; i >= 0; i--) {
          if (_otpControllers[i].text.isNotEmpty) {
            _otpControllers[i].clear();
            _focusNodes[i].requestFocus();
            break;
          }
        }
      } else {
        for (int i = 0; i < 4; i++) {
          if (_otpControllers[i].text.isEmpty) {
            _otpControllers[i].text = value;
            if (i < 3) _focusNodes[i + 1].requestFocus();
            break;
          }
        }
      }
    });
  }

  Future<void> verifyOTP() async {
    final String enteredOTP = _otpControllers.map((c) => c.text).join();

    if (enteredOTP.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the complete OTP.")),
      );
      return;
    }

    final String apiUrl =
        "https://greenwallet-6a1m.onrender.com/api/users/verify-otp"
        "?email=${widget.email}&otp=$enteredOTP";

    try {
      FocusScope.of(context).unfocus(); // Hide keyboard before sending request

      setState(() {
        _isLoading = true;
      });

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"accept": "application/json"},
      );

      setState(() {
        _isLoading = false;
      });

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // ✅ OTP verified successfully
        String token = data['token']; // Extract token

        // ✅ Save token for later authentication
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("auth_token", token);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("OTP Verified! Continue Registration.")),
        );

        // Navigate to Setup page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Setup()),
        );
      } else {
        // ❌ OTP verification failed
        setState(() {
          invalidOtp = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? "Invalid OTP!")),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Startup()),
            );
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30,
              height: 4,
              decoration: BoxDecoration(
                color: Bcolor.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: 5),
            Container(
              width: 30,
              height: 4,
              decoration: BoxDecoration(
                color: Bcolor.indicatorcolor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: 5),
            Container(
              width: 30,
              height: 4,
              decoration: BoxDecoration(
                color: Bcolor.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.headphones),
            onPressed: () {
              // Add support functionality here
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Verify your Email",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Verifying OTP for ${widget.email}",
                  // Show email from CreateAccount
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(4, (index) => _otpField(index)),
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: isButtonActive ? verifyOTP : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(310, 50),
                    backgroundColor:
                        isButtonActive ? const Color(0xFF3F2771) : Colors.grey,
                    // Change color based on field status // Disabled color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 20,
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Verify",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
                const SizedBox(height: 20),
                Text(
                  "00:${secondsRemaining.toString().padLeft(2, '0')}",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Didn't get the code? ",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    TextButton(
                      onPressed: secondsRemaining == 0
                          ? () {
                              setState(() {
                                secondsRemaining = 59;
                                startTimer();
                              });
                            }
                          : null,
                      child: Text(
                        "Resend",
                        style: TextStyle(
                          fontSize: 14,
                          color: secondsRemaining == 0
                              ? Colors.purple
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _otpField(int index) {
    return SizedBox(
      width: 50,
      height: 60,
      child: TextFormField(
        controller: _otpControllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 24),
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: (value) {
          if (value.isNotEmpty && index < 3) {
            FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
          }
        },
        onEditingComplete: () {
          if (index > 0 && _otpControllers[index].text.isEmpty) {
            FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
          }
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
