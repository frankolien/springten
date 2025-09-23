import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:springten/models/user_model.dart';
import 'package:springten/services/api_service.dart';
import 'package:springten/providers/auth_provider.dart';

// Wallet state class
class WalletState {
  final bool isLoading;
  final WalletBalance? balance;
  final WalletInfo? walletInfo;
  final String? error;

  const WalletState({
    this.isLoading = false,
    this.balance,
    this.walletInfo,
    this.error,
  });

  WalletState copyWith({
    bool? isLoading,
    WalletBalance? balance,
    WalletInfo? walletInfo,
    String? error,
  }) {
    return WalletState(
      isLoading: isLoading ?? this.isLoading,
      balance: balance ?? this.balance,
      walletInfo: walletInfo ?? this.walletInfo,
      error: error ?? this.error,
    );
  }
}

// Wallet notifier
class WalletNotifier extends StateNotifier<WalletState> {
  WalletNotifier(this._ref) : super(const WalletState());

  final Ref _ref;

  // Get wallet balance
  Future<void> getWalletBalance() async {
    final token = _ref.read(authTokenProvider);
    if (token == null) {
      state = state.copyWith(error: 'No authentication token');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final response = await ApiService.getWalletBalance(token);
      final balance = WalletBalance.fromJson(response);
      
      state = state.copyWith(
        isLoading: false,
        balance: balance,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  // Get wallet info
  Future<void> getWalletInfo() async {
    final token = _ref.read(authTokenProvider);
    if (token == null) {
      state = state.copyWith(error: 'No authentication token');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final response = await ApiService.getWalletInfo(token);
      final walletInfo = WalletInfo.fromJson(response);
      
      state = state.copyWith(
        isLoading: false,
        walletInfo: walletInfo,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }


  // Refresh all wallet data
  Future<void> refreshWalletData() async {
    await Future.wait([
      getWalletBalance(),
      getWalletInfo(),
    ]);
  }

  // Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Wallet provider
final walletProvider = StateNotifierProvider<WalletNotifier, WalletState>((ref) {
  return WalletNotifier(ref);
});

// Convenience providers
final walletBalanceProvider = Provider<WalletBalance?>((ref) {
  return ref.watch(walletProvider).balance;
});

final walletInfoProvider = Provider<WalletInfo?>((ref) {
  return ref.watch(walletProvider).walletInfo;
});

final walletErrorProvider = Provider<String?>((ref) {
  return ref.watch(walletProvider).error;
});

final walletLoadingProvider = Provider<bool>((ref) {
  return ref.watch(walletProvider).isLoading;
});
