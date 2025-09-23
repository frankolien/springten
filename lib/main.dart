import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:springten/splash_screen/splash_screen.dart';
import 'package:springten/screens/create_a_wallet/onboarding.dart';
import 'package:springten/screens/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    const ProviderScope(
      child: SpringtenApp(),
    ),
  );
}

class SpringtenApp extends ConsumerWidget {
  const SpringtenApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
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
      routes: {
        '/onboarding': (context) => const Onboarding(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}