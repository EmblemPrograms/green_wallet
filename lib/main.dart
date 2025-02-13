import 'package:flutter/material.dart';
import 'package:green_wallet/Splash_Screen.dart';
import 'package:green_wallet/dbase/mongodb.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDatabase.connect();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
  ));
}