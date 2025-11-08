import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../pages/Signin.dart';
import '../widgets/textborder.dart';

class BvnEntry extends StatefulWidget {
  const BvnEntry({super.key});

  @override
  State<BvnEntry> createState() => _BvnEntryState();
}

class _BvnEntryState extends State<BvnEntry> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _bvnController = TextEditingController();
  bool _isLoading = false;
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _bvnController.addListener(_validateForm);
  }

  void _validateForm() {
    final bvnValid = _bvnController.text.length == 11;

    setState(() {
      _isButtonEnabled = bvnValid;
    });
  }

  Future<void> _verifyBVN() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("auth_token");

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Authentication error. ")),
      );
      return;
    }

    const apiUrl =
        "https://greenwallet-6a1m.onrender.com/api/users/users/kyc/verify-tier1";
    final uri = Uri.parse("$apiUrl?token=$token");

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "bvn": _bvnController.text.trim(),
        },
      );

      final data = jsonDecode(response.body);
      final message =  "BVN Verification completed";

      setState(() => _isLoading = false);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.green),
        );

        if (!context.mounted) return;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const CustomDialogWidget1(),
        );

        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const Signin()),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  void dispose() {
    _bvnController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    /// Title
                    const Text(
                      "Enter your BVN",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),

                    /// Subtitle
                    const Text(
                      "To comply with legal requirements, we kindly request your Bank Verification Number (BVN).",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 30),

                    /// BVN Input Field
                    const Text(
                      "BVN",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: _bvnController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: 'Enter your BVN',
                        enabledBorder: Bcolor.enabledBorder,
                        counterText: "",
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 11,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'BVN is required';
                        }
                        if (value.length != 11) {
                          return 'BVN must be 11 digits';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    const SizedBox(height: 380),

                    /// Verify Button
                    ElevatedButton(
                      onPressed: _isButtonEnabled
                          ? () {
                              if (_formKey.currentState!.validate()) {
                                _verifyBVN(); // ✅ actually verify with backend
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isButtonEnabled
                            ? const Color(0xFF3F2771)
                            : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        "Verify",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),

        // 🌀 FULL SCREEN LOADING SPINNER OVERLAY
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.4),
            child: const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF3F2771),
                strokeWidth: 4,
              ),
            ),
          ),
      ],
    );
  }
}

class CustomDialogWidget1 extends StatelessWidget {
  const CustomDialogWidget1({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      if (context.mounted) {
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Signin()),
        );
      }
    });

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
                color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/Done.png', height: 150, width: 150),
            const SizedBox(height: 10),
            const Text(
              "BVN Verified Successfully",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            const Text(
              "Sign in to Access Your Account",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

String? filltextbox(String? text) {
  if (text == null || text.trim().isEmpty) {
    return 'Field cannot be empty';
  }
  return null;
}
