import 'package:flutter/material.dart';
import 'package:green_wallet/Splash_Screen.dart';
import 'package:green_wallet/pages/Take_Photo.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TakePhoto(),
  ));
}