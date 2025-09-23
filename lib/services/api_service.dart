import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api';
  
  // Headers for API requests
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Headers with JWT token
  static Map<String, String> getAuthHeaders(String token) => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };

  // Login user (for existing wallet users)
  static Future<Map<String, dynamic>> loginUser({
    required String username,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: headers,
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Login failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get wallet balance
  static Future<Map<String, dynamic>> getWalletBalance(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/wallet/balance'),
        headers: getAuthHeaders(token),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get balance: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get wallet info
  static Future<Map<String, dynamic>> getWalletInfo(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/wallet/info'),
        headers: getAuthHeaders(token),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get wallet info: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }


  // Create wallet only (no username/email required)
  static Future<Map<String, dynamic>> createWalletOnly() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/create-wallet'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create wallet: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Import wallet using recovery phrase
  static Future<Map<String, dynamic>> importWallet(String recoveryPhrase) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/import-wallet'),
        headers: headers,
        body: jsonEncode({
          'recoveryPhrase': recoveryPhrase,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to import wallet: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

}
