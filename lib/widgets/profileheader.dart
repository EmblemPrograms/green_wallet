import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:green_wallet/Card/Account_details.dart';
import 'package:green_wallet/provider/kyc_provider.dart';
import 'package:green_wallet/services/auth_service.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  String _fullName = "User Name";

  @override
  void initState() {
    super.initState();
    _loadFullName();
  }

  Future<void> _loadFullName() async {
    final profile = await AuthService.getUserProfile();
    setState(() {
      _fullName = profile["full_name"] ?? "User Name";
    });
  }

  @override
  Widget build(BuildContext context) {
    final kycTier = context.watch<KycProvider>().kycTier;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AccountDetails()),
        );
      },
      child: Row(
        children: [
          // 👤 Avatar + Tier Badge
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.2),
                radius: 24,
                child: const Icon(Icons.person, color: Colors.white, size: 26),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getTierColor(kycTier),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "Tier $kycTier",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 10),

          // 👋 Greeting + Name
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Good Morning",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                _fullName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 🎨 Helper for KYC tier color
  Color _getTierColor(String tier) {
    switch (tier) {
      case "1":
        return Colors.amber.shade700;
      case "2":
        return Colors.green.shade600;
      case "3":
        return Colors.blue.shade600;
      default:
        return Colors.grey;
    }
  }
}
