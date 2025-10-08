import 'package:flutter/material.dart';
import 'package:green_wallet/provider/kyc_provider.dart';
import 'package:provider/provider.dart';
import 'package:green_wallet/Splash_Screen.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => KycProvider()..loadKycTier()),
      ],
      child: const MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
