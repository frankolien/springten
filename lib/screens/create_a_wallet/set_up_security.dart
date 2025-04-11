import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:springten/screens/create_a_wallet/recovery_phase.dart';
class SetupSecurity extends StatefulWidget {
  const SetupSecurity({super.key});

  @override
  State<SetupSecurity> createState() => _SetupSecurityState();
}

class _SetupSecurityState extends State<SetupSecurity> {

  bool _isChecked = false;
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return  Scaffold(
      backgroundColor: Color.fromARGB(1, 36, 36, 36),
       appBar: AppBar(
         title: Text('Set up Security',style: TextStyle(color: Colors.white70,fontSize: 20),),
         centerTitle: false,
         backgroundColor: Colors.black,

       ),
       //backgroundColor: Colors.black26,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Protect your wallet',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white54
                ),
              ),
              SizedBox(height: 10),
              Text('Adding biometric security ensures that only you can access your wallet.'),
              SizedBox(height:10 ),
              Card(
                color: Colors.black45 ,
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(
                       Icons.face_unlock_outlined,
                        color: Colors.white54,
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Text('Face Id',style: TextStyle(color: Colors.white54),),
                            //SizedBox(height: 10,),
                          Text('User Face ID Authentication',),
                        ],
                      ),
                      SizedBox(width: screenWidth * 0.16),
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
              ),
              SizedBox(height: screenHeight * 0.5,),
              Center(
                child: SizedBox(
                  height: 50,
                  width: 350,
                  child: TextButton(onPressed: (){
                    Navigator.pushNamed(context, '/recoveryPhase');
                  }, child: Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.black,
                    ),

                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white
                  ),
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
