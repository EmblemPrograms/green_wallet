import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:green_wallet/pages/Create_account.dart';
import 'package:green_wallet/pages/Setup.dart';
import 'package:green_wallet/widgets/textborder.dart';

class Verify extends StatefulWidget {
  const Verify({super.key});

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  int secondsRemaining = 59;
  late Timer timer;
  bool invalidOtp = false;

  // Controllers for the OTP fields
  final TextEditingController pin1 = TextEditingController();
  final TextEditingController pin2 = TextEditingController();
  final TextEditingController pin3 = TextEditingController();
  final TextEditingController pin4 = TextEditingController();

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    pin1.dispose();
    pin2.dispose();
    pin3.dispose();
    pin4.dispose();
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
  bool areFieldsFilled() {
    return pin1.text.isNotEmpty &&
        pin2.text.isNotEmpty &&
        pin3.text.isNotEmpty &&
        pin4.text.isNotEmpty;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateAccount()),
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
                  "Please enter the OTP sent to the email address\n"
                      "you provided to verify your email address",
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
                  children: [
                    _otpField(pin1),
                    _otpField(pin2),
                    _otpField(pin3),
                    _otpField(pin4),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  invalidOtp ? 'Invalid Otp!' : '',
                  style: const TextStyle(fontSize: 14, color: Colors.red),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    final otp =
                        pin1.text + pin2.text + pin3.text + pin4.text;
                    if (otp == "1234") {
                      setState(() {
                        invalidOtp = false;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Setup()),
                      );
                    } else {
                      setState(() {
                        invalidOtp = true;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(310, 50),
                    backgroundColor: areFieldsFilled()
                      ? const Color(0xFF3F2771)
                      : Colors.grey, // Change color based on field status // Disabled color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 20,
                    ),
                  ),
                  child: const Text(
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

  Widget _otpField(TextEditingController controller) {
    return SizedBox(
      width: 50,
      height: 60,
      child: TextFormField(
        controller: controller,
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          } else if (value.isEmpty) {
            FocusScope.of(context).previousFocus();
          }
        },
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 24),
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          hintText: "0",
          hintStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
