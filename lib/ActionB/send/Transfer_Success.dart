import 'package:flutter/material.dart';

class TransferSuccess extends StatelessWidget {
  final String accountName;
  final double amount;
  final String reference;

  const TransferSuccess({
    super.key,
    required this.accountName,
    required this.amount,
    required this.reference,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Transfer Successful",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Icon(Icons.check_circle, color: Color(0xFF3F2771), size: 100),
            const SizedBox(height: 30),
            Text(
              "₦${amount.toStringAsFixed(2)}",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "sent to $accountName",
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Reference:",
                    style: TextStyle(color: Colors.grey, fontSize: 14)),
                Text(reference,
                    style: const TextStyle(
                        color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Date:",
                    style: TextStyle(color: Colors.grey, fontSize: 14)),
                Text(
                  "${DateTime.now().toLocal()}".split('.')[0],
                  style: const TextStyle(
                      color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F2771),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  "Done",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
