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

    // Navigate to the next screen after 5 seconds
    Future.delayed(Duration(seconds: 7), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Startup()),
      );
    });
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

