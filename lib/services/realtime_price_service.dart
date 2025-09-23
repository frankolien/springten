import 'dart:async';
import 'package:springten/services/crypto_service.dart';

class RealtimePriceService {
  static final RealtimePriceService _instance = RealtimePriceService._internal();
  factory RealtimePriceService() => _instance;
  RealtimePriceService._internal();

  final StreamController<Map<String, CryptoPriceData>> _priceController = 
      StreamController<Map<String, CryptoPriceData>>.broadcast();
  
  Timer? _updateTimer;
  Map<String, CryptoPriceData> _currentPrices = {};
  final List<String> _supportedCoins = CryptoService.getSupportedCoins();
  bool _isUsingMockData = false;

  Stream<Map<String, CryptoPriceData>> get priceStream => _priceController.stream;
  bool get isUsingMockData => _isUsingMockData;

  void startRealtimeUpdates() {
    _fetchInitialPrices();
    _startPriceUpdates();
  }

  void stopRealtimeUpdates() {
    _updateTimer?.cancel();
    _updateTimer = null;
  }

  void _fetchInitialPrices() async {
    try {
      final prices = await CryptoService.getCryptoPrices(_supportedCoins);
      _currentPrices.clear();
      
      prices.forEach((coinId, data) {
        _currentPrices[coinId] = CryptoPriceData(
          id: coinId,
          symbol: _getSymbolFromId(coinId),
          name: _getNameFromId(coinId),
          price: (data['usd'] ?? 0.0).toDouble(),
          change24h: (data['usd_24h_change'] ?? 0.0).toDouble(),
          lastUpdated: DateTime.now(),
        );
      });
      
      _isUsingMockData = false;
      _priceController.add(Map.from(_currentPrices));
    } catch (e) {
      print('Error fetching initial prices: $e');
      // Initialize with mock data if API fails
      _isUsingMockData = true;
      _initializeMockPrices();
    }
  }

  void _initializeMockPrices() {
    _currentPrices.clear();
    
    final basePrices = {
      'ethereum': 2500.0,
      'bitcoin': 45000.0,
      'binancecoin': 300.0,
      'solana': 100.0,
      'polygon': 0.8,
      'chainlink': 15.0,
      'avalanche-2': 25.0,
      'cardano': 0.5,
    };

    for (String coinId in _supportedCoins) {
      final basePrice = basePrices[coinId] ?? 100.0;
      final variation = (DateTime.now().millisecondsSinceEpoch % 100 - 50) / 100.0;
      final price = basePrice * (1 + variation);
      final change24h = (DateTime.now().millisecondsSinceEpoch % 200 - 100) / 10.0;
      
      _currentPrices[coinId] = CryptoPriceData(
        id: coinId,
        symbol: _getSymbolFromId(coinId),
        name: _getNameFromId(coinId),
        price: price,
        change24h: change24h,
        lastUpdated: DateTime.now(),
      );
    }
    
    _isUsingMockData = true;
    _priceController.add(Map.from(_currentPrices));
  }

  void _startPriceUpdates() {
    _updateTimer?.cancel();
    _updateTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _updatePrices();
    });
  }

  void _updatePrices() async {
    try {
      final prices = await CryptoService.getCryptoPrices(_supportedCoins);
      
      prices.forEach((coinId, data) {
        final newPrice = (data['usd'] ?? 0.0).toDouble();
        final change24h = (data['usd_24h_change'] ?? 0.0).toDouble();
        
        _currentPrices[coinId] = CryptoPriceData(
          id: coinId,
          symbol: _getSymbolFromId(coinId),
          name: _getNameFromId(coinId),
          price: newPrice,
          change24h: change24h,
          lastUpdated: DateTime.now(),
        );
      });
      
      _isUsingMockData = false;
      _priceController.add(Map.from(_currentPrices));
    } catch (e) {
      print('Error updating prices: $e');
      // Continue with existing prices instead of failing
      // The mock data fallback is already handled in CryptoService
    }
  }

  String _getSymbolFromId(String coinId) {
    final symbolMap = {
      'ethereum': 'ETH',
      'binancecoin': 'BNB',
      'bitcoin': 'BTC',
      'cardano': 'ADA',
      'solana': 'SOL',
      'polygon': 'MATIC',
      'chainlink': 'LINK',
      'avalanche-2': 'AVAX',
    };
    return symbolMap[coinId] ?? coinId.toUpperCase();
  }

  String _getNameFromId(String coinId) {
    final nameMap = {
      'ethereum': 'Ethereum',
      'binancecoin': 'BNB',
      'bitcoin': 'Bitcoin',
      'cardano': 'Cardano',
      'solana': 'Solana',
      'polygon': 'Polygon',
      'chainlink': 'Chainlink',
      'avalanche-2': 'Avalanche',
    };
    return nameMap[coinId] ?? coinId;
  }

  Map<String, CryptoPriceData> getCurrentPrices() => Map.from(_currentPrices);
  
  CryptoPriceData? getPrice(String coinId) => _currentPrices[coinId];

  void dispose() {
    _updateTimer?.cancel();
    _priceController.close();
  }
}

class CryptoPriceData {
  final String id;
  final String symbol;
  final String name;
  final double price;
  final double change24h;
  final DateTime lastUpdated;

  const CryptoPriceData({
    required this.id,
    required this.symbol,
    required this.name,
    required this.price,
    required this.change24h,
    required this.lastUpdated,
  });

  bool get isPositive => change24h >= 0;
  bool get isNegative => change24h < 0;

  String get formattedPrice => '\$${price.toStringAsFixed(2)}';
  String get formattedChange => '${change24h >= 0 ? '+' : ''}${change24h.toStringAsFixed(2)}%';
}
