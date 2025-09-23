import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:springten/services/contract_service.dart';

// Contract state
class ContractState {
  final TokenInfo? tokenInfo;
  final NFTCollectionInfo? nftInfo;
  final List<MarketplaceItem> marketplaceItems;
  final bool isLoading;
  final String? error;

  const ContractState({
    this.tokenInfo,
    this.nftInfo,
    this.marketplaceItems = const [],
    this.isLoading = false,
    this.error,
  });

  ContractState copyWith({
    TokenInfo? tokenInfo,
    NFTCollectionInfo? nftInfo,
    List<MarketplaceItem>? marketplaceItems,
    bool? isLoading,
    String? error,
  }) {
    return ContractState(
      tokenInfo: tokenInfo ?? this.tokenInfo,
      nftInfo: nftInfo ?? this.nftInfo,
      marketplaceItems: marketplaceItems ?? this.marketplaceItems,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// Contract notifier
class ContractNotifier extends StateNotifier<ContractState> {
  ContractNotifier() : super(const ContractState()) {
    _initializeContracts();
  }

  Future<void> _initializeContracts() async {
    state = state.copyWith(isLoading: true);
    
    try {
      final tokenInfo = await ContractService.getTokenInfo();
      final nftInfo = await ContractService.getNFTCollectionInfo();
      final marketplaceItems = await ContractService.getMarketplaceItems();
      
      state = state.copyWith(
        tokenInfo: tokenInfo,
        nftInfo: nftInfo,
        marketplaceItems: marketplaceItems,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refreshContracts() async {
    await _initializeContracts();
  }

  Future<void> loadMarketplaceItems() async {
    try {
      final items = await ContractService.getMarketplaceItems();
      state = state.copyWith(marketplaceItems: items);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Contract provider
final contractProvider = StateNotifierProvider<ContractNotifier, ContractState>((ref) {
  return ContractNotifier();
});

// Convenience providers
final tokenInfoProvider = Provider<TokenInfo?>((ref) {
  return ref.watch(contractProvider).tokenInfo;
});

final nftInfoProvider = Provider<NFTCollectionInfo?>((ref) {
  return ref.watch(contractProvider).nftInfo;
});

final marketplaceItemsProvider = Provider<List<MarketplaceItem>>((ref) {
  return ref.watch(contractProvider).marketplaceItems;
});

final isLoadingContractsProvider = Provider<bool>((ref) {
  return ref.watch(contractProvider).isLoading;
});

final contractErrorProvider = Provider<String?>((ref) {
  return ref.watch(contractProvider).error;
});
