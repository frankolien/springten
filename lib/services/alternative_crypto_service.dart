import 'dart:convert';
import 'package:http/http.dart' as http;

class AlternativeCryptoService {
  // Using CoinCap API as alternative (has better rate limits)
  static const String _baseUrl = 'https://api.coincap.io/v2';
  
  // Get real-time price for multiple cryptocurrencies
  static Future<Map<String, dynamic>> getCryptoPrices(List<String> coinIds) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/assets'),
        headers: {
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final assets = data['data'] as List<dynamic>;
        
        final result = <String, dynamic>{};
        
        // Map CoinCap IDs to our coin IDs
        final idMapping = {
          'ethereum': 'ethereum',
          'bitcoin': 'bitcoin',
          'binancecoin': 'binance-coin',
          'solana': 'solana',
          'polygon': 'matic-network',
          'chainlink': 'chainlink',
          'avalanche-2': 'avalanche',
          'cardano': 'cardano',
        };
        
        for (String coinId in coinIds) {
          final coincapId = idMapping[coinId];
          if (coincapId != null) {
            final asset = assets.firstWhere(
              (a) => a['id'] == coincapId,
              orElse: () => null,
            );
            
            if (asset != null) {
              result[coinId] = {
                'usd': double.parse(asset['priceUsd'] ?? '0'),
                'usd_24h_change': double.parse(asset['changePercent24Hr'] ?? '0'),
              };
            }
          }
        }
        
        return result;
      } else {
        throw Exception('Failed to fetch crypto prices: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
