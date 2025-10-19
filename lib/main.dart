import 'package:flutter/material.dart';
import 'package:green_wallet/Card/Select_pin.dart';
import 'package:green_wallet/pages/AccountSetup.dart';
import 'package:green_wallet/pages/Continue.dart';
import 'package:green_wallet/pages/Create_account.dart';
import 'package:green_wallet/pages/IDVerify.dart';
import 'package:green_wallet/pages/Notice.dart';
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
        //SplashScreen
        '/loading': (context) => const SplashScreen(),
        '/home': (context) => const hompage(),
        '/selfie': (context) => const Selfie(),
        //Pages
        '/Account': (context) => const Setup(),
        '/bvn': (context) => const BvnEntry(),
        '/Continue': (context) => const Continue(),
        '/Create': (context) => const CreateAccount(),
        '/IDVerify': (context) => const IDVerify(),
        // '/Notice': (context) => const Notice(),
        '/Selectpin': (context) => const SelectPin(),
        '/home': (context) => const hompage(),
        '/selfie': (context) => const Selfie(),
        '/Account': (context) => const Setup(),
        '/bvn': (context) => const BvnEntry(),
        '/Continue': (context) => const Continue(),
        '/Create': (context) => const CreateAccount(),
        '/IDVerify': (context) => const IDVerify(),
        '/Notice': (context) => const Notice(),
        '/loading': (context) => const SplashScreen(),
        '/home': (context) => const hompage(),
        '/selfie': (context) => const Selfie(),
        '/Account': (context) => const Setup(),
        '/bvn': (context) => const BvnEntry(),
        '/Continue': (context) => const Continue(),
        '/Create': (context) => const CreateAccount(),
        '/IDVerify': (context) => const IDVerify(),
        '/Notice': (context) => const Notice(),
      },
    );
  }
}
