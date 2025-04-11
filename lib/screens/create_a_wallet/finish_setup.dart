import 'package:flutter/material.dart';

class FinishSetup extends StatefulWidget {
  const FinishSetup({super.key});

  @override
  State<FinishSetup> createState() => _FinishSetupState();
}

class _FinishSetupState extends State<FinishSetup> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a wallet',style: TextStyle(color: Colors.white54),),
        centerTitle: false,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black26,
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('You are all set!',style: TextStyle(color: Colors.grey,fontSize: 30,fontWeight: FontWeight.bold),),
            SizedBox(height: 10),
            Text('You can now fully enjoy using your wallet',style: TextStyle(color: Colors.grey),),
            SizedBox(height: screenHeight * 0.6,),
            SizedBox(
              height: 52,
              width: 350,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                    padding: EdgeInsets.symmetric(vertical: 14),
                ),
                  onPressed: (){

              },
                  child: Text('Get Started',style: TextStyle(color: Colors.black,fontSize: 17),)

              ),
            )
          ],
        ),
      ),
    );
  }
}
