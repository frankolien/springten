import 'dart:async';

import 'package:flutter/material.dart';
import 'package:springten/screens/create_a_wallet/onboarding.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
    double _opacity = 0.0; // Initial opacity for the text
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0; // Update the opacity to make the text fully visible
      });
    });

    // Set a timer to navigate to the next screen after a delay
    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Onboarding()), // Replace HomeScreen with your next screen
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'lib/images/logo.png',
          //width: 100,
          //height: 100,
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}