import 'package:flutter/material.dart';
import 'package:springten/screens/onboarding.dart';
import 'dart:async';




/*class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  double _opacity = 1.0; // Initial opacity of the image

  void _navigateToSecondPage() async {
    // Start the fade-out animation
    setState(() {
      _opacity = 0.0;
    });
    // Wait for the animation to complete
    await Future.delayed(const Duration(milliseconds: 500));

    // Navigate to the second page
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) => const Onboarding(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );

    // Reset the opacity after navigation (optional)
    setState(() {
      _opacity = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(1, 36, 36, 36),
      body: Center(
        child: GestureDetector(
          onTap: _navigateToSecondPage,
          child: AnimatedOpacity(
            opacity: _opacity,
            duration: const Duration(milliseconds: 500),
            child: Image.asset(
              'Assets/logo.png',
            ),
          ),
        ),
      ),
    );
  }
}*/


class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {

  @override
  void initState() {
    super.initState();
    // Navigate to the home screen after 3 seconds
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/onboarding');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset(
          'Assets/logo.png',
        ),
      ),
    );
  }
}

