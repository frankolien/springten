import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:springten/screens/create_a_wallet/set_up_security.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.height;
    return Scaffold(
       backgroundColor: const Color.fromARGB(1, 36, 36, 36),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 70),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                  'Assets/logo.png',
                width: 40,
              ),
              SizedBox(height: 19),
              Text(
                  'Welcome to Springten',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text('A boring Ethereum wallet built for DeFi & NFTs'),
              SizedBox(height: screenWidth *0.4),
              SizedBox(
                height: 53,
                width: 350,
                child: ElevatedButton(
                    onPressed: (){
                      Navigator.pushNamed(context, '/setupSecurity');
                    },
                    child: Text(
                        'Create a wallet',
                    style: TextStyle(
                      color: Colors.black,
                      //fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),

                    ),
                   style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.yellowAccent,
                   ),

                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 53,
                width: 350,
                child: ElevatedButton(
                  onPressed: (){
                  Navigator.pushNamed(context, '/finishSetup');
                  },
                  child: Text(
                    'I already have a wallet',
                  style: TextStyle(
                    color: Colors.white
                  ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),

                ),
              ),

            ],
          ),
        ),
      ),
    );
   }
  }
