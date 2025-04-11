import 'package:flutter/material.dart';

class RecoveryPhase extends StatefulWidget {
  const RecoveryPhase({super.key});

  @override
  State<RecoveryPhase> createState() => _RecoveryPhaseState();
}

class _RecoveryPhaseState extends State<RecoveryPhase> {
  final List<String> recoveryWords = [
    "embrace", "the", "journey", "with", "courage", "explore",
    "new", "paths", "discover", "endless", "possibilities", "ahead"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Secret Recovery Phrase',style: TextStyle(color: Colors.white70,fontSize: 20),textAlign: TextAlign.start,),
        centerTitle: false,
        backgroundColor: Colors.black,

      ),
      backgroundColor: Colors.black26,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Protect your wallet",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "This is the only way to recover your account. Please store it safely.",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: recoveryWords.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    margin: EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Text(
                          "${index + 1}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 16),
                        Text(
                          recoveryWords[index],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
              Navigator.pushNamed(context, '/finishSetup');
              },
              child: Center(
                child: Text("Ok, I saved it somewhere safe",),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
