import 'dart:async';
import 'dart:math';
import 'package:springten/models/nft_collection_model.dart';

class RealtimeNFTService {
  static final RealtimeNFTService _instance = RealtimeNFTService._internal();
  factory RealtimeNFTService() => _instance;
  RealtimeNFTService._internal();

  final StreamController<List<NFTCollection>> _collectionsController = 
      StreamController<List<NFTCollection>>.broadcast();
  
  final StreamController<NFTCollection> _featuredCollectionController = 
      StreamController<NFTCollection>.broadcast();

  Timer? _updateTimer;
  List<NFTCollection> _collections = [];
  NFTCollection? _featuredCollection;
  final Random _random = Random();

  Stream<List<NFTCollection>> get collectionsStream => _collectionsController.stream;
  Stream<NFTCollection> get featuredCollectionStream => _featuredCollectionController.stream;

  void startRealtimeUpdates() {
    _initializeCollections();
    _startPriceUpdates();
  }

  void stopRealtimeUpdates() {
    _updateTimer?.cancel();
    _updateTimer = null;
  }

  void _initializeCollections() {
    _collections = [
      NFTCollection(
        id: '1',
        name: 'RENGA',
        creator: 'RENGA-inc',
        imageUrl: 'https://i.seadn.io/gs/2fmyry3prsd1/0x394e3d3044fc89fcdd966d3cb35ac0b32b0cda91/0?w=500&auto=format',
        floorPrice: 0.0432,
        floorPriceChange: 2.4,
        totalItems: 8354,
        totalVolume: 52300.0,
        volumeChange: 15.2,
        isVerified: true,
        isTrending: true,
        category: 'Art',
        description: 'A collection of unique digital art pieces',
        tags: ['art', 'digital', 'unique'],
        lastUpdated: DateTime.now(),
      ),
      NFTCollection(
        id: '2',
        name: 'Moonbirds',
        creator: 'PROOF',
        imageUrl: 'https://i.seadn.io/gs/2fmyry3prsd1/0x23581767a106ae21c074b2276d25e5c3e136a68b/0?w=500&auto=format',
        floorPrice: 2.66,
        floorPriceChange: -3.2,
        totalItems: 10000,
        totalVolume: 125000.0,
        volumeChange: -8.5,
        isVerified: true,
        isTrending: false,
        category: 'PFPs',
        description: 'A collection of pixelated owl avatars',
        tags: ['pfp', 'owl', 'pixelated'],
        lastUpdated: DateTime.now(),
      ),
      NFTCollection(
        id: '3',
        name: 'Bored Ape Yacht Club',
        creator: 'Yuga Labs',
        imageUrl: 'https://i.seadn.io/gs/2fmyry3prsd1/0xbc4ca0eda7647a8ab7c2061c2e118a18a936f13d/0?w=500&auto=format',
        floorPrice: 12.5,
        floorPriceChange: 1.8,
        totalItems: 10000,
        totalVolume: 2500000.0,
        volumeChange: 5.2,
        isVerified: true,
        isTrending: true,
        category: 'PFPs',
        description: 'A collection of 10,000 unique Bored Ape NFTs',
        tags: ['ape', 'exclusive', 'community'],
        lastUpdated: DateTime.now(),
      ),
      NFTCollection(
        id: '4',
        name: 'CryptoPunks',
        creator: 'Larva Labs',
        imageUrl: 'https://i.seadn.io/gs/2fmyry3prsd1/0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb/0?w=500&auto=format',
        floorPrice: 45.2,
        floorPriceChange: -2.1,
        totalItems: 10000,
        totalVolume: 5000000.0,
        volumeChange: -1.5,
        isVerified: true,
        isTrending: false,
        category: 'PFPs',
        description: 'The original NFT collection that started it all',
        tags: ['original', 'punk', 'vintage'],
        lastUpdated: DateTime.now(),
      ),
      NFTCollection(
        id: '5',
        name: 'Azuki',
        creator: 'Chiru Labs',
        imageUrl: 'https://i.seadn.io/gs/2fmyry3prsd1/0xed5af388653567af2f388e6224dc7c4b3241c544/0?w=500&auto=format',
        floorPrice: 3.8,
        floorPriceChange: 4.2,
        totalItems: 10000,
        totalVolume: 850000.0,
        volumeChange: 12.8,
        isVerified: true,
        isTrending: true,
        category: 'PFPs',
        description: 'A collection inspired by anime and manga',
        tags: ['anime', 'manga', 'japanese'],
        lastUpdated: DateTime.now(),
      ),
      NFTCollection(
        id: '6',
        name: 'Doodles',
        creator: 'Doodles',
        imageUrl: 'https://i.seadn.io/gs/2fmyry3prsd1/0x8a90cab2b38dba80c64b7734e58ee1db38b6d9e0/0?w=500&auto=format',
        floorPrice: 1.2,
        floorPriceChange: -1.5,
        totalItems: 10000,
        totalVolume: 320000.0,
        volumeChange: -3.2,
        isVerified: true,
        isTrending: false,
        category: 'Art',
        description: 'A collection of colorful, hand-drawn characters',
        tags: ['colorful', 'hand-drawn', 'fun'],
        lastUpdated: DateTime.now(),
      ),
    ];

    _featuredCollection = _collections.first;
    _collectionsController.add(List.from(_collections));
    _featuredCollectionController.add(_featuredCollection!);
  }

  void _startPriceUpdates() {
    _updateTimer?.cancel();
    _updateTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _updateCollectionPrices();
    });
  }

  void _updateCollectionPrices() {
    final updatedCollections = _collections.map((collection) {
      // Generate realistic price changes (-2% to +2%)
      final priceChange = (_random.nextDouble() - 0.5) * 0.04;
      final newFloorPrice = (collection.floorPrice * (1 + priceChange)).clamp(0.001, double.infinity);
      
      // Generate volume changes (-5% to +5%)
      final volumeChange = (_random.nextDouble() - 0.5) * 0.1;
      final newTotalVolume = (collection.totalVolume * (1 + volumeChange)).clamp(0.0, double.infinity);
      
      // Calculate percentage changes
      final floorPriceChange = ((newFloorPrice - collection.floorPrice) / collection.floorPrice) * 100;
      final volumeChangePercent = ((newTotalVolume - collection.totalVolume) / collection.totalVolume) * 100;
      
      // Update trending status based on recent performance
      final isTrending = floorPriceChange > 1.0 || volumeChangePercent > 5.0;

      return collection.copyWith(
        floorPrice: newFloorPrice,
        floorPriceChange: floorPriceChange,
        totalVolume: newTotalVolume,
        volumeChange: volumeChangePercent,
        isTrending: isTrending,
        lastUpdated: DateTime.now(),
      );
    }).toList();

    _collections = updatedCollections;
    _collectionsController.add(List.from(_collections));

    // Update featured collection if it's the first one
    if (_featuredCollection?.id == _collections.first.id) {
      _featuredCollection = _collections.first;
      _featuredCollectionController.add(_featuredCollection!);
    }
  }

  List<NFTCollection> getCollections() => List.from(_collections);
  NFTCollection? getFeaturedCollection() => _featuredCollection;

  void dispose() {
    _updateTimer?.cancel();
    _collectionsController.close();
    _featuredCollectionController.close();
  }
}
