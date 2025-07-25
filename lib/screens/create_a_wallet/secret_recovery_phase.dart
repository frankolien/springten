import 'package:flutter/material.dart';
import 'package:springten/screens/create_a_wallet/set_up_security.dart';

class SecretRecoveryPhase extends StatefulWidget {
  const SecretRecoveryPhase({super.key});

  @override
  State<SecretRecoveryPhase> createState() => _SecretRecoveryPhaseState();
}

class _SecretRecoveryPhaseState extends State<SecretRecoveryPhase> {
  bool _isChecked = false;
  
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Set up security', style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500)),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text('Protect Your Wallet',style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            )),
          ),
          const Text('Adding biometric security ensures that only you can access your wallet.',style: TextStyle(color: Colors.grey ),),
const SizedBox(height: 20),

Container(
  padding: const EdgeInsets.all(16),   
  //width: isSmallScreen ? screenWidth * 0.5 : screenWidth * 0.55,
  width: cardWidth,



            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(10),
            ),
            /*child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Secret Recovery Phrase', style: TextStyle(color: Colors.white, fontSize: 18)),
                SizedBox(height: 10),
                Text('Your secret recovery phrase is the only way to recover your wallet if you lose access. Write it down and keep it safe.', style: TextStyle(color: Colors.grey)),
              ],
            ),*/
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                  backgroundColor: Colors.grey[800],
                  child: Image.asset('lib/images/face_id.png'),
                ),
                const SizedBox(width: 10),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Face Id',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
                    Text("User Face ID Authentication",style: TextStyle(color: Colors.grey),),
                    //Spacer(),
                   
                    
                  ],
                ),

                  ],
                ),
                
                //SizedBox(width: ,),
                Checkbox(
                 
                        value: _isChecked ,
                        onChanged: (bool? newValue) {
                          setState(() {
                            _isChecked = newValue ?? false;
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5), // Rounded corners
                        ),
                      ),
              ],
            ),

          ),
          const Spacer(),
           SizedBox(height: screenHeight * 0.5,),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Center(
                  child: SizedBox(
                    height: screenWidth *0.15,
                    width: screenWidth * 0.9,
                    child: TextButton(onPressed: (){
                      //Navigator.pushNamed(context, '/recoveryPhase');
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SetUpSecurity()));
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white
                    ), child: Text(
                      'Continue',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                
                    ),
                    ),
                  ),
                ),
              ),

        ],
      ),
    );
  }
}