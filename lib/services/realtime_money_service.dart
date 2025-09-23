import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:springten/services/contract_service.dart';

class RealtimeMoneyService {
  static final RealtimeMoneyService _instance = RealtimeMoneyService._internal();
  factory RealtimeMoneyService() => _instance;
  RealtimeMoneyService._internal();

  // Stream controllers for real-time data
  final StreamController<WalletBalance> _balanceController = StreamController<WalletBalance>.broadcast();
  final StreamController<List<Transaction>> _transactionController = StreamController<List<Transaction>>.broadcast();
  final StreamController<GasPrice> _gasPriceController = StreamController<GasPrice>.broadcast();
  final StreamController<PortfolioValue> _portfolioController = StreamController<PortfolioValue>.broadcast();
  final StreamController<StakingInfo> _stakingController = StreamController<StakingInfo>.broadcast();

  // Timers for periodic updates
  Timer? _balanceTimer;
  Timer? _transactionTimer;
  Timer? _gasPriceTimer;
  Timer? _portfolioTimer;
  Timer? _stakingTimer;

  // RPC URL for local Hardhat node
  static const String _rpcUrl = 'http://127.0.0.1:8545';

  // Streams
  Stream<WalletBalance> get balanceStream => _balanceController.stream;
  Stream<List<Transaction>> get transactionStream => _transactionController.stream;
  Stream<GasPrice> get gasPriceStream => _gasPriceController.stream;
  Stream<PortfolioValue> get portfolioStream => _portfolioController.stream;
  Stream<StakingInfo> get stakingStream => _stakingController.stream;

  // Start all real-time updates
  void startRealtimeUpdates() {
    print('🚀 Starting real-time money updates...');
    
    // Start balance updates every 5 seconds
    _startBalanceUpdates();
    
    // Start transaction monitoring every 10 seconds
    _startTransactionUpdates();
    
    // Start gas price updates every 30 seconds
    _startGasPriceUpdates();
    
    // Start portfolio updates every 15 seconds
    _startPortfolioUpdates();
    
    // Start staking updates every 60 seconds
    _startStakingUpdates();
  }

  // Stop all real-time updates
  void stopRealtimeUpdates() {
    print('🛑 Stopping real-time money updates...');
    _balanceTimer?.cancel();
    _transactionTimer?.cancel();
    _gasPriceTimer?.cancel();
    _portfolioTimer?.cancel();
    _stakingTimer?.cancel();
  }

  // Real-time balance updates
  void _startBalanceUpdates() {
    _balanceTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      try {
        final balance = await _fetchWalletBalance();
        _balanceController.add(balance);
      } catch (e) {
        print('Error fetching balance: $e');
      }
    });
  }

  // Real-time transaction monitoring
  void _startTransactionUpdates() {
    _transactionTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      try {
        final transactions = await _fetchRecentTransactions();
        _transactionController.add(transactions);
      } catch (e) {
        print('Error fetching transactions: $e');
      }
    });
  }

  // Real-time gas price updates
  void _startGasPriceUpdates() {
    _gasPriceTimer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      try {
        final gasPrice = await _fetchGasPrice();
        _gasPriceController.add(gasPrice);
      } catch (e) {
        print('Error fetching gas price: $e');
      }
    });
  }

  // Real-time portfolio updates
  void _startPortfolioUpdates() {
    _portfolioTimer = Timer.periodic(const Duration(seconds: 15), (timer) async {
      try {
        final portfolio = await _calculatePortfolioValue();
        _portfolioController.add(portfolio);
      } catch (e) {
        print('Error calculating portfolio: $e');
      }
    });
  }

  // Real-time staking updates
  void _startStakingUpdates() {
    _stakingTimer = Timer.periodic(const Duration(seconds: 60), (timer) async {
      try {
        final staking = await _fetchStakingInfo();
        _stakingController.add(staking);
      } catch (e) {
        print('Error fetching staking info: $e');
      }
    });
  }

  // Fetch wallet balance from blockchain
  Future<WalletBalance> _fetchWalletBalance() async {
    try {
      // Simulate fetching balance from blockchain
      // In a real app, you'd make actual RPC calls
      final response = await http.post(
        Uri.parse(_rpcUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'jsonrpc': '2.0',
          'method': 'eth_getBalance',
          'params': ['0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266', 'latest'],
          'id': 1,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final balanceHex = data['result'];
        final balanceWei = int.parse(balanceHex.substring(2), radix: 16);
        final balanceEth = balanceWei / 1000000000000000000; // Convert wei to ETH

        return WalletBalance(
          ethBalance: balanceEth,
          usdValue: balanceEth * 2000, // Simulate ETH price
          lastUpdated: DateTime.now(),
        );
      } else {
        throw Exception('Failed to fetch balance');
      }
    } catch (e) {
      // Return mock data if RPC fails
      return WalletBalance(
        ethBalance: 10.0 + (DateTime.now().millisecondsSinceEpoch % 100) / 100,
        usdValue: 20000.0 + (DateTime.now().millisecondsSinceEpoch % 1000),
        lastUpdated: DateTime.now(),
      );
    }
  }

  // Fetch recent transactions
  Future<List<Transaction>> _fetchRecentTransactions() async {
    // Simulate recent transactions
    final now = DateTime.now();
    return [
      Transaction(
        hash: '0x${DateTime.now().millisecondsSinceEpoch.toRadixString(16)}',
        from: '0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266',
        to: '0x70997970C51812dc3A010C7d01b50e0d17dc79C8',
        value: '0.1',
        gasUsed: '21000',
        status: TransactionStatus.success,
        timestamp: now.subtract(const Duration(minutes: 5)),
        type: TransactionType.send,
      ),
      Transaction(
        hash: '0x${(DateTime.now().millisecondsSinceEpoch + 1).toRadixString(16)}',
        from: '0x70997970C51812dc3A010C7d01b50e0d17dc79C8',
        to: '0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266',
        value: '0.05',
        gasUsed: '21000',
        status: TransactionStatus.success,
        timestamp: now.subtract(const Duration(minutes: 15)),
        type: TransactionType.receive,
      ),
      Transaction(
        hash: '0x${(DateTime.now().millisecondsSinceEpoch + 2).toRadixString(16)}',
        from: '0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266',
        to: ContractService.getContractAddresses()['token']!,
        value: '0.0',
        gasUsed: '50000',
        status: TransactionStatus.pending,
        timestamp: now.subtract(const Duration(minutes: 2)),
        type: TransactionType.contract,
      ),
    ];
  }

  // Fetch current gas price
  Future<GasPrice> _fetchGasPrice() async {
    try {
      final response = await http.post(
        Uri.parse(_rpcUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'jsonrpc': '2.0',
          'method': 'eth_gasPrice',
          'params': [],
          'id': 1,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final gasPriceHex = data['result'];
        final gasPriceWei = int.parse(gasPriceHex.substring(2), radix: 16);
        final gasPriceGwei = gasPriceWei / 1000000000; // Convert wei to gwei

        return GasPrice(
          gwei: gasPriceGwei,
          usd: gasPriceGwei * 0.000002, // Simulate USD cost
          lastUpdated: DateTime.now(),
        );
      } else {
        throw Exception('Failed to fetch gas price');
      }
    } catch (e) {
      // Return mock data if RPC fails
      return GasPrice(
        gwei: 20.0 + (DateTime.now().millisecondsSinceEpoch % 10),
        usd: 0.00004 + (DateTime.now().millisecondsSinceEpoch % 100) / 1000000,
        lastUpdated: DateTime.now(),
      );
    }
  }

  // Calculate portfolio value
  Future<PortfolioValue> _calculatePortfolioValue() async {
    // Simulate portfolio calculation
    final ethBalance = 10.0 + (DateTime.now().millisecondsSinceEpoch % 100) / 100;
    final ethPrice = 2000.0 + (DateTime.now().millisecondsSinceEpoch % 100);
    final springBalance = 1000.0 + (DateTime.now().millisecondsSinceEpoch % 50);
    final springPrice = 0.1 + (DateTime.now().millisecondsSinceEpoch % 10) / 100;

    return PortfolioValue(
      totalValue: (ethBalance * ethPrice) + (springBalance * springPrice),
      ethValue: ethBalance * ethPrice,
      springValue: springBalance * springPrice,
      change24h: (DateTime.now().millisecondsSinceEpoch % 200) - 100,
      lastUpdated: DateTime.now(),
    );
  }

  // Fetch staking information
  Future<StakingInfo> _fetchStakingInfo() async {
    // Simulate staking info
    final stakedAmount = 100.0 + (DateTime.now().millisecondsSinceEpoch % 50);
    final rewards = stakedAmount * 0.1 / 365; // 10% APY
    final totalRewards = rewards * (DateTime.now().millisecondsSinceEpoch % 30);

    return StakingInfo(
      stakedAmount: stakedAmount,
      pendingRewards: totalRewards,
      apy: 10.0,
      totalEarned: totalRewards * 2,
      lastUpdated: DateTime.now(),
    );
  }

  // Manual refresh methods
  Future<void> refreshBalance() async {
    try {
      final balance = await _fetchWalletBalance();
      _balanceController.add(balance);
    } catch (e) {
      print('Error refreshing balance: $e');
    }
  }

  Future<void> refreshTransactions() async {
    try {
      final transactions = await _fetchRecentTransactions();
      _transactionController.add(transactions);
    } catch (e) {
      print('Error refreshing transactions: $e');
    }
  }

  Future<void> refreshGasPrice() async {
    try {
      final gasPrice = await _fetchGasPrice();
      _gasPriceController.add(gasPrice);
    } catch (e) {
      print('Error refreshing gas price: $e');
    }
  }

  // Dispose resources
  void dispose() {
    stopRealtimeUpdates();
    _balanceController.close();
    _transactionController.close();
    _gasPriceController.close();
    _portfolioController.close();
    _stakingController.close();
  }
}

// Data models
class WalletBalance {
  final double ethBalance;
  final double usdValue;
  final DateTime lastUpdated;

  WalletBalance({
    required this.ethBalance,
    required this.usdValue,
    required this.lastUpdated,
  });
}

class Transaction {
  final String hash;
  final String from;
  final String to;
  final String value;
  final String gasUsed;
  final TransactionStatus status;
  final DateTime timestamp;
  final TransactionType type;

  Transaction({
    required this.hash,
    required this.from,
    required this.to,
    required this.value,
    required this.gasUsed,
    required this.status,
    required this.timestamp,
    required this.type,
  });
}

enum TransactionStatus { pending, success, failed }
enum TransactionType { send, receive, contract, stake, unstake }

class GasPrice {
  final double gwei;
  final double usd;
  final DateTime lastUpdated;

  GasPrice({
    required this.gwei,
    required this.usd,
    required this.lastUpdated,
  });
}

class PortfolioValue {
  final double totalValue;
  final double ethValue;
  final double springValue;
  final double change24h;
  final DateTime lastUpdated;

  PortfolioValue({
    required this.totalValue,
    required this.ethValue,
    required this.springValue,
    required this.change24h,
    required this.lastUpdated,
  });
}

class StakingInfo {
  final double stakedAmount;
  final double pendingRewards;
  final double apy;
  final double totalEarned;
  final DateTime lastUpdated;

  StakingInfo({
    required this.stakedAmount,
    required this.pendingRewards,
    required this.apy,
    required this.totalEarned,
    required this.lastUpdated,
  });
}
