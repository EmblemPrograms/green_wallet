import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../services/auth_service.dart';
import 'NCard.dart';
import 'homepage.dart';

class SetPin extends StatefulWidget {
  const SetPin({Key? key}) : super(key: key);

  @override
  State<SetPin> createState() => _SetPinState();
}

class _SetPinState extends State<SetPin> {
  String _fullName = "Loading...";
  final List<TextEditingController> _controllers =
  List.generate(4, (_) => TextEditingController());
  bool isButtonActive = false;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    for (var controller in _controllers) {
      controller.addListener(_checkPinComplete);
    }
  }

  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _fullName = prefs.getString("full_name") ?? "User";
    });
  }

  void _checkPinComplete() {
    final active = _controllers.every((c) => c.text.isNotEmpty);
    if (isButtonActive != active) {
      setState(() => isButtonActive = active);
    }
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _onKeyPress(String value) {
    if (value == 'backspace') {
      for (int i = _controllers.length - 1; i >= 0; i--) {
        if (_controllers[i].text.isNotEmpty) {
          _controllers[i].clear();
          break;
        }
      }
    } else {
      for (final controller in _controllers) {
        if (controller.text.isEmpty) {
          controller.text = value;
          break;
        }
      }
    }
  }

  Future<void> _handlePinSubmission() async {
    final pin = _controllers.map((c) => c.text).join();

    if (pin.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid 4-digit PIN")),
      );
      return;
    }

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF3F2771)),
      ),
    );

    try {
      final prefs = await SharedPreferences.getInstance();
      final cardType = prefs.getString('card_type') ?? '';
      final cardBrand = prefs.getString('card_brand') ?? '';
      final currency = prefs.getString('currency') ?? '';
      final cardLimit = prefs.getString('card_limit') ?? '';
      final initialAmount = prefs.getDouble('initial_amount')?.toString() ?? '0';

      final token = await AuthService.getToken();

      if (token == null) {
        if (context.mounted) Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Authentication token not found")),
        );
        return;
      }

      final response = await http.post(
        Uri.parse('https://greenwallet-6a1m.onrender.com/api/cards/create?token=$token'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'card_type': cardType,
          'card_brand': cardBrand,
          'card_limit': cardLimit,
          'currency': currency,
          'initial_amount': initialAmount,
          'pin': pin,
        },
      );

      if (context.mounted) Navigator.of(context).pop(); // Close loading

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['data'] != null && data['data']['card_id'] != null) {
          await AuthService.saveUserProfile(
            fullName: (await AuthService.getFullName()) ?? '',
            email: (await AuthService.getEmail()) ?? '',
            cardId: data['data']['card_id'],
          );
        }

        // ✅ Show success dialog
        if (context.mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const CustomDialogWidget(),
          );
        }
      } else {
        debugPrint("❌ Failed: ${response.statusCode} - ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to create card. Please Check Pin and try again.")),
        );
      }
    } catch (e) {
      if (context.mounted) Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error 404: card not available")),
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
            const Text(
              "Enter your PIN!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Enter a 4-digit code you use for transaction",
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return SizedBox(
                  width: 55,
                  child: TextField(
                    controller: _controllers[index],
                    obscureText: true,
                    readOnly: true,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    style: const TextStyle(fontSize: 24),
                    decoration: InputDecoration(
                      counterText: "",
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
            const SizedBox(height: 100),

            ElevatedButton(
              onPressed: isButtonActive ? _handlePinSubmission : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor:
                isButtonActive ? const Color(0xFF3F2771) : Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text("Create Card Now",
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: GridView.builder(
                itemCount: 12,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.8,
                ),
                itemBuilder: (context, index) {
                  String keyValue;
                  Widget keyChild;

                  if (index < 9) {
                    keyValue = '${index + 1}';
                    keyChild = Text(keyValue,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold));
                  } else if (index == 9) {
                    keyValue = '';
                    keyChild = const SizedBox();
                  } else if (index == 10) {
                    keyValue = '0';
                    keyChild = const Text('0',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold));
                  } else {
                    keyValue = 'backspace';
                    keyChild = const Icon(Icons.backspace_outlined, size: 24);
                  }

                  return GestureDetector(
                    onTap: keyValue.isEmpty ? null : () => _onKeyPress(keyValue),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: keyValue == 'backspace'
                            ? Colors.grey[300]
                            : Colors.white,
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: keyChild,
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

class CustomDialogWidget extends StatefulWidget {
  const CustomDialogWidget({Key? key}) : super(key: key);

  @override
  State<CustomDialogWidget> createState() => _CustomDialogWidgetState();
}

class _CustomDialogWidgetState extends State<CustomDialogWidget> {
  @override
  void initState() {
    super.initState();
    _navigateToCardScreen();
  }

  void _navigateToCardScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      if (context.mounted) {
        Navigator.of(context).pop(); // Close dialog
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Ncard()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white, // ✅ Added white background color
          borderRadius: BorderRadius.circular(20),

        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/Done.png', height: 150, width: 150),
            const SizedBox(height: 10),
            const Text(
              "Card Created Successfully",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              "Please keep it safe and do not share it with anyone",
              style: TextStyle(fontSize: 14, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
