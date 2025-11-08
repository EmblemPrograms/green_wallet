import 'package:flutter/material.dart';
import 'package:green_wallet/profile/Pre_pin.dart';
import 'package:green_wallet/profile/security/Verify_Otp.dart';
import 'package:green_wallet/profile/security/loginpass.dart';

import '../../services/auth_service.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  bool enableBiometrics = false;

  Future<void> _navigateToOtp() async {
    try {
      // ✅ Try fetching email from AuthService
      String? email = await AuthService.getEmail();

      // ✅ Handle if email isn’t saved yet
      if (email == null || email.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email not found. Please log in again.')),
        );
        return;
      }

      // ✅ Navigate to OTP screen with fetched email
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Otp(email: email),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching email: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Security Settings",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildSecurityOption(
              icon: Icons.grid_view_rounded,
              title: "Transaction PIN",
              subtitle: "Change your transaction pin",
              onTap: _navigateToOtp,
            ),
            _buildSecurityOption(
              icon: Icons.lock_outline,
              title: "Login Password",
              subtitle: "Change your login password",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                      const ChangePass()),
                );// Navigate to password change screen
              },
            ),
            _buildBiometricToggle(),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: Icon(icon, color: const Color(0xFF3F2771)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 13, color: Colors.grey)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildBiometricToggle() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white,
            child: Icon(Icons.fingerprint, color: const Color(0xFF3F2771)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Enable Biometrics",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                SizedBox(height: 2),
                Text("Login with your biometrics",
                    style: TextStyle(fontSize: 13, color: Colors.grey)),
              ],
            ),
          ),
          Switch(
            value: enableBiometrics,
            onChanged: (val) {
              setState(() {
                enableBiometrics = val;
              });
            },
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
