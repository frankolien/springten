import 'dart:convert';
import 'package:http/http.dart' as http;

class TransactionService {
  static const String _baseUrl = 'http://localhost:8080/api/transactions';
  
  // Send a transaction
  static Future<TransactionResponse> sendTransaction({
    required String fromAddress,
    required String toAddress,
    required double amount,
    required String privateKey,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/send'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'fromAddress': fromAddress,
          'toAddress': toAddress,
          'amount': (amount * 1e18).toInt(), // Convert ETH to Wei
          'privateKey': privateKey,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return TransactionResponse.fromJson(data);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? 'Transaction failed');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Send transaction with custom gas
  static Future<TransactionResponse> sendTransactionWithGas({
    required String fromAddress,
    required String toAddress,
    required double amount,
    required String privateKey,
    required int gasPrice,
    required int gasLimit,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/send-with-gas'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'fromAddress': fromAddress,
          'toAddress': toAddress,
          'amount': (amount * 1e18).toInt(), // Convert ETH to Wei
          'privateKey': privateKey,
          'gasPrice': gasPrice,
          'gasLimit': gasLimit,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return TransactionResponse.fromJson(data);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? 'Transaction failed');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get current gas price
  static Future<int> getGasPrice() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/gas-price'));
      
      if (response.statusCode == 200) {
        return int.parse(response.body);
      } else {
        throw Exception('Failed to get gas price');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get gas price in Gwei
  static Future<double> getGasPriceInGwei() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/gas-price-gwei'));
      
      if (response.statusCode == 200) {
        return double.parse(response.body);
      } else {
        throw Exception('Failed to get gas price');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Estimate gas limit
  static Future<int> estimateGas({
    required String fromAddress,
    required String toAddress,
    required double amount,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/estimate-gas'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'fromAddress': fromAddress,
          'toAddress': toAddress,
          'amount': (amount * 1e18).toInt(), // Convert ETH to Wei
        }),
      );

      if (response.statusCode == 200) {
        return int.parse(response.body);
      } else {
        throw Exception('Failed to estimate gas');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Check transaction status
  static Future<bool> getTransactionStatus(String transactionHash) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/status/$transactionHash'),
      );

      if (response.statusCode == 200) {
        return response.body.toLowerCase() == 'true';
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}

class TransactionResponse {
  final String transactionHash;
  final String status;
  final int? gasUsed;
  final int? gasPrice;
  final String fromAddress;
  final String toAddress;
  final int amount;
  final String? error;

  const TransactionResponse({
    required this.transactionHash,
    required this.status,
    this.gasUsed,
    this.gasPrice,
    required this.fromAddress,
    required this.toAddress,
    required this.amount,
    this.error,
  });

  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    return TransactionResponse(
      transactionHash: json['transactionHash'] ?? '',
      status: json['status'] ?? '',
      gasUsed: json['gasUsed'],
      gasPrice: json['gasPrice'],
      fromAddress: json['fromAddress'] ?? '',
      toAddress: json['toAddress'] ?? '',
      amount: json['amount'] ?? 0,
      error: json['error'],
    );
  }

  bool get isSuccess => status == 'PENDING' || status == 'SUCCESS';
  bool get isFailed => status == 'FAILED';
  
  double get amountInEth => amount / 1e18; // Convert Wei to ETH
}
