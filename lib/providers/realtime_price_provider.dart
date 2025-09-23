import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:springten/services/realtime_price_service.dart';

// Real-time price state
class RealtimePriceState {
  final Map<String, CryptoPriceData> prices;
  final bool isLoading;
  final String? error;
  final DateTime? lastUpdated;

  const RealtimePriceState({
    this.prices = const {},
    this.isLoading = false,
    this.error,
    this.lastUpdated,
  });

  RealtimePriceState copyWith({
    Map<String, CryptoPriceData>? prices,
    bool? isLoading,
    String? error,
    DateTime? lastUpdated,
  }) {
    return RealtimePriceState(
      prices: prices ?? this.prices,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

// Real-time price notifier
class RealtimePriceNotifier extends StateNotifier<RealtimePriceState> {
  final RealtimePriceService _priceService = RealtimePriceService();

  RealtimePriceNotifier() : super(const RealtimePriceState()) {
    _initializeService();
  }

  void _initializeService() {
    _priceService.startRealtimeUpdates();
    
    // Listen to price stream
    _priceService.priceStream.listen((prices) {
      state = state.copyWith(
        prices: prices,
        lastUpdated: DateTime.now(),
        isLoading: false,
        error: null,
      );
    });
  }

  void refreshPrices() {
    state = state.copyWith(isLoading: true);
    // The real-time service will automatically update the state
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  @override
  void dispose() {
    _priceService.dispose();
    super.dispose();
  }
}

// Real-time price provider
final realtimePriceProvider = StateNotifierProvider<RealtimePriceNotifier, RealtimePriceState>((ref) {
  return RealtimePriceNotifier();
});

// Convenience providers
final isLoadingPriceProvider = Provider<bool>((ref) {
  return ref.watch(realtimePriceProvider).isLoading;
});

final priceErrorProvider = Provider<String?>((ref) {
  return ref.watch(realtimePriceProvider).error;
});

final pricesProvider = Provider<Map<String, CryptoPriceData>>((ref) {
  return ref.watch(realtimePriceProvider).prices;
});

// Individual price providers
final ethPriceProvider = Provider<CryptoPriceData?>((ref) {
  final prices = ref.watch(pricesProvider);
  return prices['ethereum'];
});

final btcPriceProvider = Provider<CryptoPriceData?>((ref) {
  final prices = ref.watch(pricesProvider);
  return prices['bitcoin'];
});

final bnbPriceProvider = Provider<CryptoPriceData?>((ref) {
  final prices = ref.watch(pricesProvider);
  return prices['binancecoin'];
});

final solPriceProvider = Provider<CryptoPriceData?>((ref) {
  final prices = ref.watch(pricesProvider);
  return prices['solana'];
});

final maticPriceProvider = Provider<CryptoPriceData?>((ref) {
  final prices = ref.watch(pricesProvider);
  return prices['polygon'];
});
