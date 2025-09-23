import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:springten/services/crypto_service.dart';

// Crypto data model
class CryptoData {
  final String id;
  final String symbol;
  final String name;
  final double price;
  final double change24h;
  final String imageUrl;

  const CryptoData({
    required this.id,
    required this.symbol,
    required this.name,
    required this.price,
    required this.change24h,
    required this.imageUrl,
  });

  factory CryptoData.fromJson(Map<String, dynamic> json) {
    return CryptoData(
      id: json['id'] ?? '',
      symbol: json['symbol']?.toUpperCase() ?? '',
      name: json['name'] ?? '',
      price: (json['current_price'] ?? 0.0).toDouble(),
      change24h: (json['price_change_percentage_24h'] ?? 0.0).toDouble(),
      imageUrl: json['image'] ?? '',
    );
  }
}

// Crypto state
class CryptoState {
  final List<CryptoData> cryptos;
  final bool isLoading;
  final String? error;
  final DateTime? lastUpdated;

  const CryptoState({
    this.cryptos = const [],
    this.isLoading = false,
    this.error,
    this.lastUpdated,
  });

  CryptoState copyWith({
    List<CryptoData>? cryptos,
    bool? isLoading,
    String? error,
    DateTime? lastUpdated,
  }) {
    return CryptoState(
      cryptos: cryptos ?? this.cryptos,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

// Crypto notifier
class CryptoNotifier extends StateNotifier<CryptoState> {
  CryptoNotifier() : super(const CryptoState());

  Future<void> loadCryptoData() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final marketData = await CryptoService.getMarketData(limit: 20);
      final cryptos = marketData.map((json) => CryptoData.fromJson(json)).toList();

      state = state.copyWith(
        cryptos: cryptos,
        isLoading: false,
        lastUpdated: DateTime.now(),
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> refreshData() async {
    await loadCryptoData();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Crypto provider
final cryptoProvider = StateNotifierProvider<CryptoNotifier, CryptoState>((ref) {
  return CryptoNotifier();
});

// Convenience providers
final isLoadingCryptoProvider = Provider<bool>((ref) {
  return ref.watch(cryptoProvider).isLoading;
});

final cryptoErrorProvider = Provider<String?>((ref) {
  return ref.watch(cryptoProvider).error;
});

final cryptosProvider = Provider<List<CryptoData>>((ref) {
  return ref.watch(cryptoProvider).cryptos;
});
