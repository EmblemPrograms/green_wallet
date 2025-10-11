import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  String? _selfieUrl; // For Cloudinary or network images
  Uint8List? _selfieBytes; // Store decoded image bytes

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final profile = await AuthService.getUserProfile();

    if (mounted) {
      setState(() {
        _fullName = profile["full_name"] ?? "User Name";

        final selfieValue = profile["selfie"];
        if (selfieValue != null && selfieValue.isNotEmpty) {
          if (selfieValue.startsWith("http")) {
            // It's a URL (Cloudinary)
            _selfieUrl = selfieValue;
          } else {
            // It's likely Base64, try decoding
            try {
              _selfieBytes = base64Decode(selfieValue);
            } catch (e) {
              debugPrint("Error decoding Base64 selfie: $e");
            }
          }
        }
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final kycTier = context.watch<KycProvider>().kycTier;

    Widget avatarWidget;

    if (_selfieBytes != null) {
      // Display Base64 selfie
      avatarWidget = CircleAvatar(
        radius: 24,
        backgroundImage: MemoryImage(_selfieBytes!),
      );
    } else if (_selfieUrl != null) {
      // Display cached Cloudinary image
      avatarWidget = CircleAvatar(
        radius: 24,
        backgroundColor: Colors.grey[300],
        backgroundImage: CachedNetworkImageProvider(_selfieUrl!),
        onBackgroundImageError: (_, __) {
          debugPrint("❌ Failed to load network selfie");
        },
      );
    } else {
      // Default placeholder
      avatarWidget = const CircleAvatar(
        radius: 24,
        backgroundColor: Colors.white24,
        child: Icon(Icons.person, color: Colors.white, size: 24),
      );
    }
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
              avatarWidget,

              // Positioned(
              //   bottom: 0,
              //   right: 0,
              //   child: Container(
              //     padding:
              //     const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              //     decoration: BoxDecoration(
              //       color: _getTierColor(kycTier),
              //       borderRadius: BorderRadius.circular(12),
              //     ),
              //     child: Text(
              //       "Tier $kycTier",
              //       style: const TextStyle(
              //         color: Colors.white,
              //         fontSize: 10,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //   ),
              // ),
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
