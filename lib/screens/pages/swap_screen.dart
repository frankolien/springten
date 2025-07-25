import 'package:flutter/material.dart';

class SwapScreen extends StatefulWidget {
  const SwapScreen({super.key});

  @override
  State<SwapScreen> createState() => _SwapScreenState();
}

class _SwapScreenState extends State<SwapScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Swap Page',
        style: TextStyle(fontSize: 24, color: Colors.white),
      ),
    );
  }
}