import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:springten/screens/create_a_wallet/wallet_created.dart';
import 'package:springten/providers/auth_provider.dart';
import 'package:springten/services/storage_service.dart';

class RecoveryPhraseScreen extends ConsumerStatefulWidget {
  final bool biometricEnabled;

  const RecoveryPhraseScreen({
    super.key,
    required this.biometricEnabled,
  });

  @override
  ConsumerState<RecoveryPhraseScreen> createState() => _RecoveryPhraseScreenState();
}

class _RecoveryPhraseScreenState extends ConsumerState<RecoveryPhraseScreen> {
  bool _isChecked = false;
  bool _isLoading = false;
  String? _errorMessage;
  List<String> _recoveryPhrase = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateRecoveryPhrase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Secret Recovery Phrase',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Protect your wallet',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'This is the only way to recover your account. Please store it safely.',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 30),

            // Recovery Phrase Grid
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(10),
              ),
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : _errorMessage != null
                      ? Column(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _errorMessage!,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _generateRecoveryPhrase,
                              child: const Text('Retry'),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            // 12 words in 2 columns
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Left column (words 1-6)
                                Expanded(
                                  child: Column(
                                    children: [
                                      for (int i = 0; i < 6 && i < _recoveryPhrase.length; i++)
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                          margin: const EdgeInsets.only(bottom: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[900],
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Colors.grey[700]!),
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                '${i + 1}.',
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                _recoveryPhrase[i],
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Right column (words 7-12)
                                Expanded(
                                  child: Column(
                                    children: [
                                      for (int i = 6; i < 12 && i < _recoveryPhrase.length; i++)
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                          margin: const EdgeInsets.only(bottom: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[900],
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Colors.grey[700]!),
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                '${i + 1}.',
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                _recoveryPhrase[i],
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
            ),

            const SizedBox(height: 30),

            // Checkbox for confirmation - only show when recovery phrase is loaded
            if (_recoveryPhrase.isNotEmpty)
              Row(
                children: [
                  Checkbox(
                    value: _isChecked,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _isChecked = newValue ?? false;
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    activeColor: Colors.white,
                    checkColor: Colors.black,
                  ),
                  const Expanded(
                    child: Text(
                      'Ok, I saved it somewhere safe',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),

            const Spacer(),

            // Continue Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: (_isChecked && _recoveryPhrase.isNotEmpty) ? _finalizeWalletCreation : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: (_isChecked && _recoveryPhrase.isNotEmpty) ? Colors.white : Colors.grey[600],
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.black)
                    : const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _generateRecoveryPhrase() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Use auth provider to create wallet
      await ref.read(authProvider.notifier).createWalletOnly();
      
      // Get the auth state to extract recovery phrase
      final authState = ref.read(authProvider);
      if (authState.isAuthenticated && authState.user != null && authState.recoveryPhrase != null) {
        // Use the actual recovery phrase from the backend
        _recoveryPhrase = authState.recoveryPhrase!.split(' ');
        
        setState(() {
          _isLoading = false;
        });
      } else {
        // Check if there's an error in the auth state
        final error = authState.error;
        throw Exception(error ?? 'Failed to create wallet - no authentication or recovery phrase');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to create wallet: $e';
        _isLoading = false;
      });
    }
  }

  void _finalizeWalletCreation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Wallet is already created and authenticated via auth provider
      final authState = ref.read(authProvider);
      if (authState.isAuthenticated && authState.user != null && authState.token != null) {
        // Store the wallet data for persistence
        await StorageService.saveAuthData(authState.token!, authState.user!);
        
        print('Wallet created successfully!');
        print('Address: ${authState.user!.walletAddress}');
        print('Token: ${authState.token}');
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const WalletCreated(),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to finalize wallet: $e';
        _isLoading = false;
      });
    }
  }
}