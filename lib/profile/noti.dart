import 'package:flutter/material.dart';
import 'package:green_wallet/Card/Profile.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool loginEmailAlert = false;
  bool transactionEmailAlert = true;
  bool transactionPushAlert = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          "Notifications",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text("Login Alerts", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            const SizedBox(height: 12),
            _buildToggleTile("Email", loginEmailAlert, (val) {
              setState(() => loginEmailAlert = val);
            }),

            const SizedBox(height: 24),
            const Text("Transaction Alerts", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            const SizedBox(height: 12),
            _buildToggleTile("Email", transactionEmailAlert, (val) {
              setState(() => transactionEmailAlert = val);
            }),
            const SizedBox(height: 12),
            _buildToggleTile("Push Notification", transactionPushAlert, (val) {
              setState(() => transactionPushAlert = val);
            }),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileP()),
                  );// Handle save logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F2771),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text("Save Changes", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleTile(String title, bool value, Function(bool) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF3F2771),
            inactiveTrackColor: Colors.grey.shade200,
            inactiveThumbColor: Colors.white,
            trackOutlineColor: WidgetStateProperty.all(Colors.grey.shade200),
          ),
        ],
      ),
    );
  }
}
