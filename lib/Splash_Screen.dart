import 'package:shared_preferences/shared_preferences.dart';
import 'package:green_wallet/pages/Signin.dart';
import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:green_wallet/pages/Startup.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    // Show the splash for 5–7 seconds so the GIF plays fully
    await Future.delayed(const Duration(seconds: 7));

    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

    if (isFirstLaunch) {
      await prefs.setBool('isFirstLaunch', false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Startup()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Signin()),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3F2771),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ✅ Display GIF as the background
          GifView.asset(
            "assets/splash.gif",  // Path to your GIF
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),

          // ✅ Your logo on top of GIF
          Center(
            child: Image.asset(
              'assets/gw21.png', // Your logo
              width: 200,
              height: 150,
            ),
          ),
        ],
      ),
    );
  }
}

