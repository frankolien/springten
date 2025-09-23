import 'package:flutter/material.dart';
import 'package:springten/screens/create_a_wallet/recovery_phrase_screen.dart';

class SecretRecoveryPhase extends StatefulWidget {
  final String username;
  final String email;
  final String fullName;
  final bool biometricEnabled;

  const SecretRecoveryPhase({
    super.key,
    required this.username,
    required this.email,
    required this.fullName,
    required this.biometricEnabled,
  });

  @override
  State<SecretRecoveryPhase> createState() => _SecretRecoveryPhaseState();
}

class _SecretRecoveryPhaseState extends State<SecretRecoveryPhase> {
  bool _isChecked = false;
  
  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 40.0),
        child: Column(
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
    width: double.infinity,
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
                  Expanded(
                    child: Row(
                      children: [
                        CircleAvatar(
                    backgroundColor: Colors.grey[800],
                    child: Image.asset('lib/images/face_id.png'),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Face Id',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
                        Text("User Face ID Authentication",style: TextStyle(color: Colors.grey),),
                        //Spacer(),
                       
                        
                      ],
                    ),
                  ),

                      ],
                    ),
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
            const SizedBox(height: 40),
            Center(
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: TextButton(onPressed: (){
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => RecoveryPhraseScreen(
                              biometricEnabled: widget.biometricEnabled,
                            ),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white
                      ), child: const Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                  
                      ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}