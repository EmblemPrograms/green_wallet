import 'package:flutter/material.dart';
import 'package:green_wallet/Card/hompage.dart';
import 'package:green_wallet/Splash_Screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: hompage(),
    //home: SplashScreen(),
  ));
}