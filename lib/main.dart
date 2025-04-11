

import 'package:flutter/material.dart';
import 'package:springten/screens/begining.dart';
import 'package:springten/screens/create_a_wallet/finish_setup.dart';
import 'package:springten/screens/create_a_wallet/recovery_phase.dart';
import 'package:springten/screens/create_a_wallet/set_up_security.dart';
import 'package:springten/screens/onboarding.dart';

void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    //home: FirstPage(),
    initialRoute: '/',
    routes: {
      '/': (context) => FirstPage(),
      '/onboarding': (context) => Onboarding(),
      '/setupSecurity': (context) => SetupSecurity(),
      '/recoveryPhase': (context) => RecoveryPhase(),
      '/finishSetup': (context) => FinishSetup(),
    },
  ));
}
