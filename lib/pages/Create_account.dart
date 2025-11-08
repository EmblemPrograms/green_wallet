import 'dart:convert';
import 'package:green_wallet/pages/Otp.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:green_wallet/widgets/textborder.dart';
import 'package:green_wallet/pages/startup.dart';
import 'package:green_wallet/pages/Signin.dart';
import 'package:country_picker/country_picker.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  // Controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Focus nodes
  final FocusNode _emailFocusNode = FocusNode();

  // Form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // States
  String _selectedCountryCode = "+1"; // Default USA
  bool _isLoading = false;
  bool _isPasswordObscured = true;
  bool _isTermsAccepted = false;

  // API Endpoint
  static const String _apiUrl =
      "https://greenwallet-6a1m.onrender.com/api/users/auth/register";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }



  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return "Enter a valid email address";
    }
    return null;
  }

  Future<void> _registerUser() async {
    final String userEmail = _emailController.text.trim();

    // Validate email before sending request
    final emailError = validateEmail(userEmail);
    if (emailError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ $emailError")),
      );
      return;
    }

    final Map<String, dynamic> userData = {
      "first_name": _firstNameController.text.trim(),
      "last_name": _lastNameController.text.trim(),
      "email": userEmail,
      "phone_number": "0${_phoneController.text.trim()}",
      "password": _passwordController.text.trim(),
    };

    try {
      setState(() => _isLoading = true);

      // Send request asynchronously, but don't wait for confirmation to navigate
      http.post(
        Uri.parse(_apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(userData),
      ).then((response) {
        // Optional: Log or handle any errors that come later
        if (response.statusCode != 200) {
          debugPrint("⚠️ Server responded with ${response.statusCode}");
          _handleErrorResponse(response);
        }
      }).catchError((error) {
        debugPrint("❌ Registration request failed: $error");
      });

      // Immediately stop loading and navigate
      setState(() => _isLoading = false);


      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Otp(email: userEmail),
        ),
      );
    } catch (error) {
      setState(() => _isLoading = false);
      debugPrint("❌ Registration error: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Network Error. Try Again")),
      );
    }
  }

  void _handleErrorResponse(http.Response response) {
    try {
      final errorData = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorData['message'] ?? "Registration failed")),
      );
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error ${response.statusCode}: ${response.body}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Startup()),
            );
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Text(
                  "Let’s Get Started",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 15),

                // First Name
                const Text(
                  "First Name",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _firstNameController, // Add this line
                  validator: filltextbox,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: 'Enter first name',
                    enabledBorder: Bcolor.enabledBorder,
                  ),
                ),
                const SizedBox(height: 10),

                // Last Name
                const Text(
                  "Last Name",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _lastNameController,
                  validator: filltextbox,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: Bcolor.enabledBorder,
                    hintText: 'Enter last name',
                  ),
                ),
                const SizedBox(height: 10),

                // Email Address
                const Text(
                  "Email Address",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _emailController,
                  validator: validateEmail,
                  focusNode: _emailFocusNode,
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: Bcolor.enabledBorder,
                    hintText: 'Enter email address',
                  ),
                ),
                const SizedBox(height: 10),

                // Phone Number
                const Text(
                  "Phone Number",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showCountryPicker(
                          context: context,
                          showPhoneCode: true, // Show phone codes
                          onSelect: (Country country) {
                            setState(() {
                              _selectedCountryCode = "+${country.phoneCode}";
                            });
                          },
                        );
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Bcolor.primaryColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(_selectedCountryCode),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        validator: filltextbox,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: Bcolor.enabledBorder,
                          hintText: 'Mobile number',
                          counterText: "",
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Password
                const Text(
                  "Password",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _passwordController,
                  validator: filltextbox,
                  obscureText: _isPasswordObscured,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: Bcolor.enabledBorder,
                    hintText: '**********',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordObscured
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordObscured = !_isPasswordObscured;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Terms and Conditions
                Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _isTermsAccepted,
                        onChanged: (bool? value) {
                          setState(() {
                            _isTermsAccepted =
                                value ?? false; // Null-safe handling
                          });
                        },
                      ),
                    ),
                    const Text(
                      'I agree to the ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      'Terms of Service ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF3F2771),
                        fontSize: 12,
                      ),
                    ),
                    const Text(
                      'and ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      'Privacy Policy',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF3F2771),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Next Button
                ElevatedButton(
                  onPressed: _isTermsAccepted
                      ? () {
                    if (_formKey.currentState!.validate()) {
                      // Explicit email validation on button press
                      final emailError = validateEmail(_emailController.text.trim());
                      if (emailError == null) {
                        _registerUser();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("❌ $emailError")),
                        );
                      }
                    }
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isTermsAccepted
                        ? const Color(0xFF3F2771)
                        : Colors.grey,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Next",
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
                const SizedBox(height: 10),

                // Sign In Prompt
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Signin(),
                            ),
                          ); // Navigate to Sign In screen
                        },
                        child: const Text(
                          "Sign in",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3F2771),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
