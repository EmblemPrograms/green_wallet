import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../services/auth_service.dart';
import 'bank.dart';
import 'SendBngn.dart';

class ngnSend extends StatefulWidget {
  const ngnSend({super.key});

  @override
  State<ngnSend> createState() => _ngnSendState();
}

class _ngnSendState extends State<ngnSend> {
  String? selectedBankName;
  String? selectedBankNip; // hidden NIP code
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  bool _isVerifying = false;

  Future<void> _verifyAccount() async {
    if (selectedBankNip == null || accountNumberController.text.isEmpty) return;

    setState(() => _isVerifying = true);

    try {
      final token = await AuthService.getToken();
      final url = Uri.parse(
          'https://greenwallet-6a1m.onrender.com/api/transactions/transfer/verify-account?token=$token');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "bank_code": selectedBankNip,
          "account_number": accountNumberController.text,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final accountName = data["attributes"]["accountName"] ?? "";
        setState(() {
          fullNameController.text = accountName;
        });
      } else {
        final error = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Verification failed: ${error['detail'] ?? 'Unknown error'}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error verifying account: $e")));
    } finally {
      setState(() => _isVerifying = false);
    }
  }

  Future<void> _createCounterparty() async {
    try {
      final token = await AuthService.getToken();
      final url = Uri.parse(
          'https://greenwallet-6a1m.onrender.com/api/transactions/transfer/counterparty/create?token=$token');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "bank_code": selectedBankNip,
          "account_number": accountNumberController.text,
          "account_name": fullNameController.text,
          "verify_name": true,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final counterpartyId = data["id"];
        debugPrint("✅ Counterparty created successfully: $counterpartyId");

        // Navigate to next page (SendBngn)
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Sendbngn(counterpartyId: counterpartyId,
              accountName: fullNameController.text,),
          ),
        );
      } else {
        final error = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "Failed to create counterparty: ${error['detail'] ?? 'Unknown error'}"),
          ),
        );
      }
    } catch (e) {
      debugPrint("Error creating counterparty: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Send to bank account",
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bank Selection
              const Text("Bank"),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () async {
                  final selected = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BankList()),
                  );

                  if (selected != null) {
                    setState(() {
                      selectedBankName = selected["name"];
                      selectedBankNip = selected["nipCode"]; // store NIP code
                      fullNameController.clear(); // reset full name if bank changed
                    });
                  }
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: TextEditingController(text: selectedBankName ?? ''),
                    decoration: InputDecoration(
                      labelText: "Select Bank",
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      suffixIcon: const Icon(Icons.arrow_drop_down),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Account Number
              const Text("Account number"),
              const SizedBox(height: 5),
              TextField(
                controller: accountNumberController,
                keyboardType: TextInputType.number,
                maxLength: 10,
                onChanged: (value) {
                  if (value.length == 10 && !_isVerifying) {
                    _verifyAccount(); // Automatically verify when 10 digits are entered
                  } else if (value.length < 10) {
                    setState(() {
                      fullNameController.clear(); // Clear name if user edits number
                    });
                  }
                },
                decoration: InputDecoration(
                  hintText: "1234567890",
                  counterText: "",
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  suffixIcon: _isVerifying
                      ? const Padding(
                    padding: EdgeInsets.all(10),
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                      : null, // No search icon
                ),
              ),


              const SizedBox(height: 20),

              // Full Name (read-only)
              const Text("Full name"),
              const SizedBox(height: 5),
              TextField(
                controller: fullNameController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: "Account name will appear here",
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),

              const SizedBox(height: 20),

              // Next Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (selectedBankNip != null &&
                      accountNumberController.text.isNotEmpty &&
                      fullNameController.text.isNotEmpty)
                      ? () async {
                    await _createCounterparty();
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3F2771),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text("Next", style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
