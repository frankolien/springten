import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:springten/models/nft_collection_model.dart';
import 'package:springten/services/realtime_nft_service.dart';

// NFT state
class NFTState {
  final List<NFTCollection> collections;
  final NFTCollection? featuredCollection;
  final bool isLoading;
  final String? error;
  final DateTime? lastUpdated;

  const NFTState({
    this.collections = const [],
    this.featuredCollection,
    this.isLoading = false,
    this.error,
    this.lastUpdated,
  });

  NFTState copyWith({
    List<NFTCollection>? collections,
    NFTCollection? featuredCollection,
    bool? isLoading,
    String? error,
    DateTime? lastUpdated,
  }) {
    return NFTState(
      collections: collections ?? this.collections,
      featuredCollection: featuredCollection ?? this.featuredCollection,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

// NFT notifier
class NFTNotifier extends StateNotifier<NFTState> {
  final RealtimeNFTService _nftService = RealtimeNFTService();

  NFTNotifier() : super(const NFTState()) {
    _initializeService();
  }

  void _initializeService() {
    _nftService.startRealtimeUpdates();
    
    // Listen to collections stream
    _nftService.collectionsStream.listen((collections) {
      state = state.copyWith(
        collections: collections,
        lastUpdated: DateTime.now(),
      );
    });

    // Listen to featured collection stream
    _nftService.featuredCollectionStream.listen((featuredCollection) {
      state = state.copyWith(
        featuredCollection: featuredCollection,
        lastUpdated: DateTime.now(),
      );
    });
  }

  void refreshData() {
    state = state.copyWith(isLoading: true);
    // The real-time service will automatically update the state
    state = state.copyWith(isLoading: false);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  @override
  void dispose() {
    _nftService.dispose();
    super.dispose();
  }
}

// NFT provider
final nftProvider = StateNotifierProvider<NFTNotifier, NFTState>((ref) {
  return NFTNotifier();
});

// Convenience providers
final isLoadingNFTProvider = Provider<bool>((ref) {
  return ref.watch(nftProvider).isLoading;
});

final nftErrorProvider = Provider<String?>((ref) {
  return ref.watch(nftProvider).error;
});

final collectionsProvider = Provider<List<NFTCollection>>((ref) {
  return ref.watch(nftProvider).collections;
});

final featuredCollectionProvider = Provider<NFTCollection?>((ref) {
  return ref.watch(nftProvider).featuredCollection;
});

// Filtered collections by category
final filteredCollectionsProvider = Provider.family<List<NFTCollection>, String>((ref, category) {
  final collections = ref.watch(collectionsProvider);
  if (category == 'All') {
    return collections;
  }
  return collections.where((collection) => collection.category == category).toList();
});

// Trending collections
final trendingCollectionsProvider = Provider<List<NFTCollection>>((ref) {
  final collections = ref.watch(collectionsProvider);
  return collections.where((collection) => collection.isTrending).toList();
});
