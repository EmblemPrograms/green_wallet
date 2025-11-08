import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/auth_service.dart';

class CardDetailsPage extends StatefulWidget {
  final String cardId;
  const CardDetailsPage({super.key, required this.cardId});

  @override
  State<CardDetailsPage> createState() => _CardDetailsPageState();
}

class _CardDetailsPageState extends State<CardDetailsPage> {
  Map<String, dynamic>? cardData;
  bool isLoading = true;

  // toggle state + loader for fetching decrypted values
  bool showSensitive = false;
  bool isFetchingSensitive = false;
  bool isCardFrozen = false;

  @override
  void initState() {
    super.initState();
    // initial fetch without relay (we still mask locally)
    fetchCardDetails(useRelay: false);
  }

  /// ✅ Freeze / Unfreeze Card
  Future<void> toggleFreezeCard() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          isCardFrozen ? 'Unfreeze Card' : 'Freeze Card',
          style: const TextStyle(
            color: Color(0xFF3F2771),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          isCardFrozen
              ? 'Are you sure you want to unfreeze this card?'
              : 'Are you sure you want to freeze this card?',
          style: const TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3F2771),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final token = await AuthService.getToken();
      if (token == null || token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Authentication token missing")),
        );
        return;
      }

      // ✅ Use widget.cardId instead of AuthService.getCardId()
      final endpoint = isCardFrozen
          ? 'https://greenwallet-6a1m.onrender.com/api/cards/unfreeze/${widget.cardId}?token=$token'
          : 'https://greenwallet-6a1m.onrender.com/api/cards/freeze/${widget.cardId}?token=$token';

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Dialog(
          backgroundColor: Colors.transparent,
          child: Center(
            child: CircularProgressIndicator(color: Color(0xFF3F2771)),
          ),
        ),
      );

      final response = await http.patch(
        Uri.parse(endpoint),
        headers: {'accept': 'application/json'},
      );

      Navigator.pop(context);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final message = data['message'] ??
            (isCardFrozen
                ? 'Card unfrozen successfully'
                : 'Card frozen successfully');

        setState(() => isCardFrozen = !isCardFrozen);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed: ${response.reasonPhrase}")),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  /// ✅ Fund Card
  void fundCard() {
    final TextEditingController amountController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Fund Card',
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF3F2771)),
        ),
        content: Form(
          key: _formKey,
          child: TextFormField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Enter Amount',
              prefixText: '\$ ',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an amount';
              }
              final amount = double.tryParse(value);
              if (amount == null || amount <= 0) {
                return 'Enter a valid amount';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3F2771),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                Navigator.pop(context);
                await _performFunding(amountController.text);
              }
            },
            child: const Text(
              'Confirm',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _performFunding(String amount) async {
    try {
      final token = await AuthService.getToken();
      if (token == null || token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Authentication token missing")),
        );
        return;
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Dialog(
          backgroundColor: Colors.transparent,
          child: Center(
            child: CircularProgressIndicator(color: Color(0xFF3F2771)),
          ),
        ),
      );

      final url =
          'https://greenwallet-6a1m.onrender.com/api/cards/fund?token=$token';

      // ✅ Use widget.cardId directly
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'card_id': widget.cardId,
          'amount': amount,
        },
      );

      Navigator.pop(context);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final message = data['message'] ?? 'Card funding successful';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Funding failed: ${response.body}")),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }




  Future<void> fetchCardDetails({bool useRelay = false}) async {
    final token = await AuthService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception("No authentication token found.");
    }

    final url =
        "https://greenwallet-6a1m.onrender.com/api/cards/details/${widget.cardId}?use_relay=$useRelay&token=$token";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          cardData = jsonResponse['data'] as Map<String, dynamic>?;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch card details');
      }
    } catch (e) {
      debugPrint("Error: $e");
      setState(() => isLoading = false);
    }
  }

  // Always show masked number by default. If showSensitive == true and card_number exists, show full.
  String displayCardNumber() {
    if (cardData == null) return '';
    final full = cardData!['card_number'] as String?;
    final last4 = cardData!['last_4'] as String?;
    if (showSensitive && full != null && full.isNotEmpty) {
      return full;
    }
    // masked fallback using last4 if present
    final suffix = (last4 != null && last4.isNotEmpty) ? last4 : '****';
    return "•••• •••• •••• $suffix";
  }

  String displayExpiry() {
    if (cardData == null) return "** / **";
    final month = cardData!['expiry_month']?.toString();
    final year = cardData!['expiry_year']?.toString();
    if (showSensitive && month != null && year != null) {
      return "${month.padLeft(2, '0')} / $year";
    }
    return "** / **";
  }

  String displayCvv() {
    if (cardData == null) return "***";
    final cvv = cardData!['cvv'] as String?;
    if (showSensitive && cvv != null && cvv.isNotEmpty) {
      return cvv;
    }
    return "***";
  }

  // Called when user taps the button to view/hide sensitive details
  Future<void> toggleSensitiveInfo() async {
    if (!showSensitive) {
      // fetch decrypted values from relay (rate-limited endpoint)
      setState(() {
        isFetchingSensitive = true;
      });

      await fetchCardDetails(useRelay: true);

      setState(() {
        isFetchingSensitive = false;
        showSensitive = true;
      });
    } else {
      // simply hide locally — do not call relay again
      setState(() {
        showSensitive = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Card Details',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : cardData == null
              ? const Center(child: Text('Unable to load card details'))
              : SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // 🌈 Virtual Card Design (kept exactly as requested)
                        Stack(
                          children: [
                            // 🎴 The Card
                            Container(
                              width: double.infinity,
                              height: 220,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF3F2771), Color(0xFF6E4CB5)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Green Wallet",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Icon(Icons.credit_card, color: Colors.white, size: 28),
                                      ],
                                    ),

                                    // Card Number (masked by default)
                                    Text(
                                      displayCardNumber(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        letterSpacing: 2.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    // Card Holder / Expiry / CVV
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Card Holder",
                                              style: TextStyle(color: Colors.white70, fontSize: 12),
                                            ),
                                            Text(
                                              cardData!['card_name'] ?? '',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Expiry",
                                              style: TextStyle(color: Colors.white70, fontSize: 12),
                                            ),
                                            Text(
                                              displayExpiry(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "CVV",
                                              style: TextStyle(color: Colors.white70, fontSize: 12),
                                            ),
                                            Text(
                                              displayCvv(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // 👁️ Positioned visibility icon
                            Positioned(
                              top: 35,
                              right: 11,
                              child: IconButton(
                                icon: Icon(
                                  showSensitive ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.white,
                                  size: 26,
                                ),
                                onPressed: isFetchingSensitive ? null : toggleSensitiveInfo,
                                tooltip: isFetchingSensitive
                                    ? 'Loading...'
                                    : (showSensitive ? 'Hide details' : 'View details'),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        // Balance Section (unchanged)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Available Balance",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "\$${cardData!['balance'] ?? '0.00'}",
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3F2771),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Toggle button — fetches decrypted values when turning on.
                        ElevatedButton.icon(
                          onPressed: toggleFreezeCard,
                          icon: Icon(
                            isCardFrozen ? Icons.lock_open : Icons.lock,
                            color: Colors.white,
                          ),
                          label: Text(
                            isCardFrozen ? 'Unfreeze Card' : 'Freeze Card',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isCardFrozen ? Colors.green : Colors.redAccent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                        ),


                        const SizedBox(height: 8),

                        ElevatedButton.icon(
                          onPressed: fundCard,
                          icon: const Icon(Icons.account_balance_wallet, color: Colors.white),
                          label: const Text(
                            'Fund Card',
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3F2771),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            minimumSize: const Size(double.infinity, 50), // full-width button
                            elevation: 4,
                          ),
                        ),

                      ],
                    ),
                  ),
              ),
    );
  }
}
