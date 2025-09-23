import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:springten/screens/create_a_wallet/onboarding.dart';
import 'package:springten/screens/pages/home_page.dart';
import 'package:springten/providers/app_initialization_provider.dart';
import 'package:springten/providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    // Initialize the app
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(appInitializationProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final initState = ref.watch(appInitializationProvider);
    final authState = ref.watch(authProvider);

    // Show loading while initializing
    if (initState.isLoading) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('lib/images/logo.png'),
                width: 100,
                height: 100,
              ),
              SizedBox(height: 20),
              CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
        backgroundColor: Colors.black,
      );
    }

    // Navigate based on authentication state - only once
    if (!_hasNavigated && initState.isInitialized) {
      _hasNavigated = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (authState.isAuthenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Onboarding()),
          );
        }
      });
    }

    return const Scaffold(
      body: Center(
        child: Image(
          image: AssetImage('lib/images/logo.png'),
          width: 100,
          height: 100,
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}