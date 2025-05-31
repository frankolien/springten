import 'dart:async';

import 'package:flutter/material.dart';
import 'package:springten/create_a_wallet/asset_blank.dart';
import 'package:springten/create_a_wallet/onboarding.dart';
import 'package:shimmer/shimmer.dart';
class Loader extends StatefulWidget {
  const Loader({super.key});

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {
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
        MaterialPageRoute(builder: (context) => const AssetBlank()), // Replace HomeScreen with your next screen
      );
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Shimmer.fromColors(
          baseColor: Colors.white,
          highlightColor: Colors.black,
          child: const Text(
            'Loading...',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      )
    );
          
          
  }
}