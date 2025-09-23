class NFTCollection {
  final String id;
  final String name;
  final String creator;
  final String imageUrl;
  final double floorPrice;
  final double floorPriceChange;
  final int totalItems;
  final double totalVolume;
  final double volumeChange;
  final bool isVerified;
  final bool isTrending;
  final String category;
  final String description;
  final List<String> tags;
  final DateTime lastUpdated;

  const NFTCollection({
    required this.id,
    required this.name,
    required this.creator,
    required this.imageUrl,
    required this.floorPrice,
    required this.floorPriceChange,
    required this.totalItems,
    required this.totalVolume,
    required this.volumeChange,
    required this.isVerified,
    required this.isTrending,
    required this.category,
    required this.description,
    required this.tags,
    required this.lastUpdated,
  });

  factory NFTCollection.fromJson(Map<String, dynamic> json) {
    return NFTCollection(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      creator: json['creator'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      floorPrice: (json['floorPrice'] ?? 0.0).toDouble(),
      floorPriceChange: (json['floorPriceChange'] ?? 0.0).toDouble(),
      totalItems: json['totalItems'] ?? 0,
      totalVolume: (json['totalVolume'] ?? 0.0).toDouble(),
      volumeChange: (json['volumeChange'] ?? 0.0).toDouble(),
      isVerified: json['isVerified'] ?? false,
      isTrending: json['isTrending'] ?? false,
      category: json['category'] ?? 'All',
      description: json['description'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      lastUpdated: DateTime.parse(json['lastUpdated'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'creator': creator,
      'imageUrl': imageUrl,
      'floorPrice': floorPrice,
      'floorPriceChange': floorPriceChange,
      'totalItems': totalItems,
      'totalVolume': totalVolume,
      'volumeChange': volumeChange,
      'isVerified': isVerified,
      'isTrending': isTrending,
      'category': category,
      'description': description,
      'tags': tags,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  NFTCollection copyWith({
    String? id,
    String? name,
    String? creator,
    String? imageUrl,
    double? floorPrice,
    double? floorPriceChange,
    int? totalItems,
    double? totalVolume,
    double? volumeChange,
    bool? isVerified,
    bool? isTrending,
    String? category,
    String? description,
    List<String>? tags,
    DateTime? lastUpdated,
  }) {
    return NFTCollection(
      id: id ?? this.id,
      name: name ?? this.name,
      creator: creator ?? this.creator,
      imageUrl: imageUrl ?? this.imageUrl,
      floorPrice: floorPrice ?? this.floorPrice,
      floorPriceChange: floorPriceChange ?? this.floorPriceChange,
      totalItems: totalItems ?? this.totalItems,
      totalVolume: totalVolume ?? this.totalVolume,
      volumeChange: volumeChange ?? this.volumeChange,
      isVerified: isVerified ?? this.isVerified,
      isTrending: isTrending ?? this.isTrending,
      category: category ?? this.category,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
