import 'package:flutter/material.dart';
import 'package:green_wallet/provider/kyc_provider.dart';
import 'package:provider/provider.dart';
import 'package:green_wallet/pages/Selfie.dart';
import 'package:green_wallet/Splash_Screen.dart';
import 'package:green_wallet/Card/hompage.dart';
import 'package:green_wallet/pages/BVN_entry.dart';



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
      title: 'Green Wallet',
      debugShowCheckedModeBanner: false,
      initialRoute: '/loading',
      routes: {
        '/loading': (context) => const SplashScreen(),
        '/home': (context) => const hompage(),
        '/bvn': (context) => const BvnEntry(),
        '/selfie': (context) => const Selfie(),
      },
    );
  }
}
