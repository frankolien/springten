import 'package:flutter/material.dart';
import 'package:springten/constant/overflow.dart';
import 'package:springten/screens/create_a_wallet/loader.dart';

class WalletCreated extends StatelessWidget {
  const WalletCreated({super.key});

  @override
  Widget build(BuildContext context) {
    final overflow = OverflowConstants.of(context);
print(overflow.cardWidth);
    return Scaffold(
       appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Create a wallet', style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500)),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.check_circle, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                'You are all set!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'You can now fully enjoy using your wallet.',
                style: TextStyle(color: Colors.grey),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: SizedBox(
                  width: overflow.cardWidth,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow, // Set the button color
                    ),
                    onPressed: () {
                      // Navigate to the next screen
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const Loader())); // Replace with your next screen
                    },
                    child: const Text('Continue',style: TextStyle(color: Colors.black),),
                  ),
                ),
              ),

          ],
        ),
      ),
    );
  }
}