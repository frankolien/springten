import 'package:flutter/material.dart';
import 'package:springten/create_a_wallet/wallet_created.dart';

class SetUpSecurity extends StatefulWidget {
  const SetUpSecurity({super.key});

  @override
  State<SetUpSecurity> createState() => _SetUpSecurityState();
}

class _SetUpSecurityState extends State<SetUpSecurity> {
  final int _phraseCount = 0;
  // List of phrases to display in the table


  final List<String> _phrases = [
    'embrace',
    'the',
    'journey',
    'with',
    'courage',
    'explore',
    'new',
    'paths',
    'discover',
    'endless',
    'possibilities',
    'ahead',
  ];
  @override
  Widget build(BuildContext context) {
       final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final isSmallScreen = screenWidth < 600; // Adjust threshold as needed
    final isLargeScreen = screenWidth >= 600; // Adjust threshold as needed
    final isTablet = screenWidth >= 600 && screenHeight >= 600; // Basic tablet detection
    final isMobile = screenWidth < 600; // Basic mobile detection
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final isLightMode = MediaQuery.of(context).platformBrightness == Brightness.light;
     late double cardWidth;
  if (isTablet && isLandscape) {
  cardWidth = screenWidth * 0.4;
} else if (isMobile && isPortrait) {
  cardWidth = screenWidth * 0.99;
} else {
  cardWidth = screenWidth * 0.6;
}
    return Scaffold(
       appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Secret Recovery phrase', style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500)),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Set Up Security',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Adding biometric security ensures that only you can access your wallet.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            // ...existing code...
            Column(
              children: [
                for (int i = 0; i < _phrases.length; i++) ...[
                  Row(
                    children: [
                      Text(
                        '${i + 1}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              _phrases[i],
              style: const TextStyle(color: Colors.white),
            ),
                        ),
                      ),
                    ],
                  ),
                  if (i < _phrases.length - 1)
                    Divider(color: Colors.grey[700]),
                ]
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: SizedBox(
                width: cardWidth,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Set the button color
                  ),
                  onPressed: () {
                    // Navigate to the next screen
                   Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const WalletCreated()),
                    );
                  },
                  child: const Text('Ok, I saved it somewhere safe', style: TextStyle(color: Colors.black)),
                ),

              ),
            ),
          
      
          ],
        ),
      ),
    );
}
}

