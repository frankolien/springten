import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:springten/providers/auth_provider.dart';
import 'package:springten/providers/wallet_provider.dart';
import 'package:springten/providers/crypto_provider.dart';
import 'package:springten/services/storage_service.dart';
import 'package:flutter/services.dart';

class AssetViewModel extends StateNotifier<AssetViewState> {
  final Ref ref;
  
  AssetViewModel(this.ref) : super(const AssetViewState());

  Future<void> loadWalletData() async {
    state = state.copyWith(isLoading: true);
    
    try {
      final walletNotifier = ref.read(walletProvider.notifier);
      final cryptoNotifier = ref.read(cryptoProvider.notifier);
      
      await Future.wait<void>([
        walletNotifier.refreshWalletData(),
        cryptoNotifier.loadCryptoData(),
      ]);
      
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      // Clear providers (this will also clear storage)
      await ref.read(authProvider.notifier).logout();
      ref.read(walletProvider.notifier).clearError();
      ref.read(cryptoProvider.notifier).clearError();
      
      // Navigate to onboarding
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/onboarding',
          (route) => false,
        );
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void copyAddress(String address, BuildContext context) {
    if (address.isNotEmpty && address != 'No address') {
      Clipboard.setData(ClipboardData(text: address));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Address copied to clipboard'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void refreshCryptoData() {
    ref.read(cryptoProvider.notifier).refreshData();
  }

  void refreshWalletData() {
    ref.read(walletProvider.notifier).refreshWalletData();
  }

  String formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  String formatAddress(String address) {
    if (address.isEmpty || address == 'No address') {
      return 'No address';
    }
    if (address.length <= 10) {
      return address;
    }
    return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
  }
}

class AssetViewState {
  final bool isLoading;
  final String? error;

  const AssetViewState({
    this.isLoading = false,
    this.error,
  });

  AssetViewState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return AssetViewState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

final assetViewModelProvider = StateNotifierProvider<AssetViewModel, AssetViewState>((ref) {
  return AssetViewModel(ref);
});
