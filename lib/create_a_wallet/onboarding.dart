import 'package:flutter/material.dart';
import 'package:springten/create_a_wallet/secret_recovery_phase.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
             //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 100.0),
                  child: Column(
                    children: [
                      Image.asset(
                    'lib/images/logo.png',
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Welcome to SpringTen',
                    style: TextStyle(fontSize: 24, color: Colors.white,fontWeight: FontWeight.bold),
                  ),
                    ],
                  ),
                ),

                
                //const SizedBox(height: 20),
                const Spacer(),

                SizedBox(
                  width: 350,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow, // Set the button color
                    ),
                    onPressed: () {
                      // Navigate to the next screen
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SecretRecoveryPhase()));
                    },
                    child: const Text('Create a new wallet',style: TextStyle(color: Colors.black),),
                  ),
                ),
                
                const SizedBox(height: 10),
                SizedBox(
                  height: 50,
                  width: 350,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800], // Set the button color
                    ),
                    onPressed: () {
                      // Navigate to the next screen
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    child: const Text('I already have a wallet',style: TextStyle(color: Colors.white),),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.black,
      
    );
  }
}