import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:springten/services/realtime_money_service.dart';

// Real-time money provider
final realtimeMoneyProvider = Provider<RealtimeMoneyService>((ref) {
  final service = RealtimeMoneyService();
  // Start real-time updates when provider is created
  service.startRealtimeUpdates();
  
  // Cleanup when provider is disposed
  ref.onDispose(() {
    service.dispose();
  });
  
  return service;
});

// Individual stream providers
final walletBalanceProvider = StreamProvider<WalletBalance>((ref) {
  final service = ref.watch(realtimeMoneyProvider);
  return service.balanceStream;
});

final transactionsProvider = StreamProvider<List<Transaction>>((ref) {
  final service = ref.watch(realtimeMoneyProvider);
  return service.transactionStream;
});

final gasPriceProvider = StreamProvider<GasPrice>((ref) {
  final service = ref.watch(realtimeMoneyProvider);
  return service.gasPriceStream;
});

final portfolioProvider = StreamProvider<PortfolioValue>((ref) {
  final service = ref.watch(realtimeMoneyProvider);
  return service.portfolioStream;
});

final stakingProvider = StreamProvider<StakingInfo>((ref) {
  final service = ref.watch(realtimeMoneyProvider);
  return service.stakingStream;
});

// Convenience providers for specific data
final currentBalanceProvider = Provider<WalletBalance?>((ref) {
  final balanceAsync = ref.watch(walletBalanceProvider);
  return balanceAsync.when(
    data: (balance) => balance,
    loading: () => null,
    error: (_, __) => null,
  );
});

final recentTransactionsProvider = Provider<List<Transaction>>((ref) {
  final transactionsAsync = ref.watch(transactionsProvider);
  return transactionsAsync.when(
    data: (transactions) => transactions,
    loading: () => [],
    error: (_, __) => [],
  );
});

final currentGasPriceProvider = Provider<GasPrice?>((ref) {
  final gasPriceAsync = ref.watch(gasPriceProvider);
  return gasPriceAsync.when(
    data: (gasPrice) => gasPrice,
    loading: () => null,
    error: (_, __) => null,
  );
});

final currentPortfolioProvider = Provider<PortfolioValue?>((ref) {
  final portfolioAsync = ref.watch(portfolioProvider);
  return portfolioAsync.when(
    data: (portfolio) => portfolio,
    loading: () => null,
    error: (_, __) => null,
  );
});

final currentStakingProvider = Provider<StakingInfo?>((ref) {
  final stakingAsync = ref.watch(stakingProvider);
  return stakingAsync.when(
    data: (staking) => staking,
    loading: () => null,
    error: (_, __) => null,
  );
});
