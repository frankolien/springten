import 'package:flutter/material.dart';
class DAppScreen extends StatefulWidget {
  const DAppScreen({super.key});

  @override
  State<DAppScreen> createState() => _DAppScreenState();
}

class _DAppScreenState extends State<DAppScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'DApps Page',
        style: TextStyle(fontSize: 24, color: Colors.white),
      ),
    );
  }
}