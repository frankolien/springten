import 'package:flutter/material.dart';
import 'package:springten/screens/pages/home_page.dart';
import 'package:springten/splash_screen/splash_screen.dart';

void main(){
  runApp( MaterialApp(
    theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1A1B23),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2A2B35),
          elevation: 0,
        ),
      ),
    debugShowCheckedModeBanner: false,
    title: 'SpringTen',
    home: const SplashScreen(),
  ));
}