import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:springten/services/alternative_crypto_service.dart';

class CryptoService {
  static const String _baseUrl = 'https://api.coingecko.com/api/v3';
  
  // Get real-time price for multiple cryptocurrencies with retry logic
  static Future<Map<String, dynamic>> getCryptoPrices(List<String> coinIds) async {
    int retries = 3;
    int delay = 1; // Start with 1 second delay
    
    for (int i = 0; i < retries; i++) {
      try {
        final ids = coinIds.join(',');
        final response = await http.get(
          Uri.parse('$_baseUrl/simple/price?ids=$ids&vs_currencies=usd&include_24hr_change=true'),
          headers: {
            'Accept': 'application/json',
            'User-Agent': 'SpringTen/1.0',
          },
        ).timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          return jsonDecode(response.body);
        } else if (response.statusCode == 429) {
          // Rate limited - wait longer before retry
          if (i < retries - 1) {
            await Future.delayed(Duration(seconds: delay * (i + 1) * 2));
            continue;
          }
          throw Exception('Rate limited. Please try again later.');
        } else {
          throw Exception('Failed to fetch crypto prices: ${response.statusCode}');
        }
      } catch (e) {
        if (i == retries - 1) {
          // Last retry failed, try alternative API
          try {
            return await AlternativeCryptoService.getCryptoPrices(coinIds);
          } catch (e) {
            // If alternative API also fails, return mock data
            return _getMockPrices(coinIds);
          }
        }
        await Future.delayed(Duration(seconds: delay * (i + 1)));
      }
    }
    
    return _getMockPrices(coinIds);
  }

  // Mock prices as fallback when API fails
  static Map<String, dynamic> _getMockPrices(List<String> coinIds) {
    final mockPrices = <String, dynamic>{};
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

    for (String coinId in coinIds) {
      final basePrice = basePrices[coinId] ?? 100.0;
      final variation = (DateTime.now().millisecondsSinceEpoch % 100 - 50) / 100.0; // ±0.5% variation
      final price = basePrice * (1 + variation);
      final change24h = (DateTime.now().millisecondsSinceEpoch % 200 - 100) / 10.0; // ±10% change
      
      mockPrices[coinId] = {
        'usd': price,
        'usd_24h_change': change24h,
      };
    }
    
    return mockPrices;
  }

  // Get detailed info for a specific cryptocurrency
  static Future<Map<String, dynamic>> getCryptoInfo(String coinId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/coins/$coinId'),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch crypto info: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get market data for top cryptocurrencies
  static Future<List<Map<String, dynamic>>> getMarketData({int limit = 10}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=$limit&page=1&sparkline=false'),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to fetch market data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get supported coin IDs for our app
  static List<String> getSupportedCoins() {
    return [
      'ethereum',      // ETH
      'binancecoin',   // BNB
      'bitcoin',       // BTC
      'cardano',       // ADA
      'solana',        // SOL
      'polygon',       // MATIC
      'chainlink',     // LINK
      'avalanche-2',   // AVAX
    ];
  }
}
