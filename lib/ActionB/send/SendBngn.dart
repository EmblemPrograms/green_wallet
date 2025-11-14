import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../services/auth_service.dart';
import 'Transfer_Success.dart';

class Sendbngn extends StatefulWidget {
  final String counterpartyId;
  final String accountName;

  const Sendbngn({
    super.key,
    required this.counterpartyId,
    required this.accountName,
  });

  @override
  State<Sendbngn> createState() => _SendbngnState();
}

class _SendbngnState extends State<Sendbngn> {
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  double _walletBalance = 0.0;
  String? _sourceAccountId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  /// 🔹 Generate a short 4-character unique reference
  String _generateShortReference() {
    const chars = '0123456789';
    final rand = Random();
    return List.generate(4, (index) => chars[rand.nextInt(chars.length)]).join();
  }


  /// 🔹 Fetch wallet + source_account_id
  Future<void> _loadUserData() async {
    String? token = await AuthService.getToken();
    if (token == null) return;

    final url = "https://greenwallet-6a1m.onrender.com/api/users/profile?token=$token";

    try {
      final response = await http.get(Uri.parse(url), headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final balance = (data['wallet_balance']?['NGN'] ?? 0).toDouble();
        String? accountId;

        // ✅ Extract source_account_id from deposit_accounts
        if (data['deposit_accounts'] != null && data['deposit_accounts'].isNotEmpty) {
          accountId = data['deposit_accounts'][0]['account_id'];
        }

        setState(() {
          _walletBalance = balance;
          _sourceAccountId = accountId;
        });

        await AuthService.saveWalletBalance(balance);
      } else {
        debugPrint("❌ Failed to fetch wallet: ${response.body}");
      }
    } catch (e) {
      debugPrint("⚠️ Error fetching wallet: $e");
    }
  }

  /// 🚀 Perform external transfer
  Future<void> _sendTransfer() async {
    String? token = await AuthService.getToken();
    if (token == null || _sourceAccountId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Unable to find source account")),
      );
      return;
    }

    final double? amount = double.tryParse(amountController.text);
    final String reason = _noteController.text.trim();
    final String reference = _generateShortReference();

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid amount")),
      );
      return;
    }

    setState(() => _isLoading = true);

    final url = "https://greenwallet-6a1m.onrender.com/api/transactions/transfer/external?token=$token";

    final body = {
      "counterparty_id": widget.counterpartyId,
      "amount": amount,
      "reason": reason.isEmpty ? "Transfer to ${widget.accountName}" : reason,
      "reference": reference,
      "source_account_id": _sourceAccountId, // ✅ Added
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint("✅ Transfer successful: $data");

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TransferSuccess(
              accountName: widget.accountName,
              amount: amount,
              reference: reference,
            ),
          ),
        );
      } else {
        debugPrint("❌ Transfer failed: ${response.body}");
        final error = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Transfer failed: ${error['detail'] ?? 'Unknown error'}")),
        );
      }
    } catch (e) {
      debugPrint("⚠️ Transfer error: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isButtonEnabled = amountController.text.isNotEmpty && !_isLoading;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              "Send to ${widget.accountName}",
              style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              "₦${_walletBalance.toStringAsFixed(2)} Available",
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("You send"),
            const SizedBox(height: 10),

            // 💰 Amount Input
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.grey.shade200,
                    ),
                    child: Row(
                      children: [
                        Image.asset('assets/ngn_flag.png', height: 20, width: 20),
                        const SizedBox(width: 5),
                        const Text("NGN"),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: amountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(hintText: "0.00", border: InputBorder.none),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Text("Note"),
            const SizedBox(height: 10),

            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                hintText: "Enter Transfer Narration",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isButtonEnabled ? _sendTransfer : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F2771),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                child: _isLoading
                    ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
                    : const Text("Send", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
