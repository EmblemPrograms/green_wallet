import 'package:flutter/material.dart';
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
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) =>Startup()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3F2771),
      body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          Image.asset(
            'assets/gw21.png', // Path to your image
            width: 120, // Adjust width as needed
            height: 80, // Adjust height as needed
             // Adjust fit as needed
          ),
         ],
      ),
              ),
    );
  }
}
