import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:green_wallet/pages/Signin.dart';
import 'package:green_wallet/pages/Create_account.dart';

class Startup extends StatefulWidget {
  const Startup({super.key});

  @override
  State<Startup> createState() => _StartupState();
}

class _StartupState extends State<Startup> {
  final List<Map<String, String>> carouselItems = [
    {
      "image": "assets/Frame1.png",
      "title": "Send money securely in just minutes",
      "subtitle":
      "Make international payments to local bank accounts almost immediately",
    },
    {
      "image": "assets/Frame2.png",
      "title": "More countries, More Access, More Reach",
      "subtitle": "Send money for transactions in their local currencies.",
    },
    {
      "image": "assets/Frame3.png",
      "title": "Safe and Seamless Transactions",
      "subtitle": "Your transactions and personal data are securely protected.",
    },
  ];

  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Prevent infinite height issue
            children: [
              SizedBox(height: 5,),
              // Carousel Slider
              CarouselSlider.builder(
                itemCount: carouselItems.length,
                itemBuilder: (context, index, realIndex) {
                  final item = carouselItems[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black,
                            ],
                            stops: [0.1, 1.9],
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.dstIn,
                        child: Image.asset(
                          item['image'] ?? '',
                          width: 264,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, size: 270),
                        ),
                      ),
                      Text(
                        item['title'] ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        item['subtitle'] ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 17,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  );
                },
                options: CarouselOptions(
                  scrollPhysics: const BouncingScrollPhysics(),
                  height: 510,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.9,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                ),
              ),
        
              // Indicators for Carousel
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  carouselItems.length,
                      (index) =>
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: currentIndex == index
                              ? const Color(0xFF3F2771)
                              : Colors.grey,
                        ),
                      ),
                ),
              ),
        
              // Buttons
              const SizedBox(height: 75),
              SizedBox(
                height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Create Account Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateAccount(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3F2771),
                        minimumSize: const Size(310, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 20,
                        ),
                      ),
                      child: const Text(
                        "Create Account",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Sign In Button
                    OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Signin(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF3F2771)),
                        minimumSize: const Size(310, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 20,
                        ),
                      ),
                      child: const Text(
                        "Sign in",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3F2771),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
