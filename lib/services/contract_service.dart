import 'dart:convert';
import 'package:http/http.dart' as http;

class ContractService {
  // Contract addresses (from localhost deployment)
  static const String _tokenAddress = '0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512';
  static const String _nftAddress = '0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0';
  static const String _marketplaceAddress = '0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9';
  
  // Local Hardhat node URL
  static const String _rpcUrl = 'http://127.0.0.1:8545';
  
  // Contract ABIs (simplified for demo)
  static const String _tokenABI = '''
  [
    {
      "inputs": [],
      "name": "name",
      "outputs": [{"internalType": "string", "name": "", "type": "string"}],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "symbol",
      "outputs": [{"internalType": "string", "name": "", "type": "string"}],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "totalSupply",
      "outputs": [{"internalType": "uint256", "name": "", "type": "uint256"}],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [{"internalType": "address", "name": "account", "type": "address"}],
      "name": "balanceOf",
      "outputs": [{"internalType": "uint256", "name": "", "type": "uint256"}],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [{"internalType": "uint256", "name": "amount", "type": "uint256"}],
      "name": "stake",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [{"internalType": "address", "name": "user", "type": "address"}],
      "name": "getStakingInfo",
      "outputs": [
        {"internalType": "uint256", "name": "stakedAmount", "type": "uint256"},
        {"internalType": "uint256", "name": "pendingRewards", "type": "uint256"},
        {"internalType": "uint256", "name": "stakingStartTime", "type": "uint256"},
        {"internalType": "bool", "name": "isActive", "type": "bool"}
      ],
      "stateMutability": "view",
      "type": "function"
    }
  ]
  ''';

  static const String _nftABI = '''
  [
    {
      "inputs": [],
      "name": "getContractInfo",
      "outputs": [
        {"internalType": "string", "name": "name", "type": "string"},
        {"internalType": "string", "name": "symbol", "type": "string"},
        {"internalType": "uint256", "name": "totalSupplyCount", "type": "uint256"},
        {"internalType": "uint256", "name": "maxSupplyCount", "type": "uint256"},
        {"internalType": "uint256", "name": "price", "type": "uint256"},
        {"internalType": "bool", "name": "active", "type": "bool"}
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [{"internalType": "address", "name": "to", "type": "address"}, {"internalType": "string", "name": "tokenURI", "type": "string"}],
      "name": "mintNFT",
      "outputs": [{"internalType": "uint256", "name": "", "type": "uint256"}],
      "stateMutability": "payable",
      "type": "function"
    },
    {
      "inputs": [{"internalType": "address", "name": "owner", "type": "address"}],
      "name": "getTokensByOwner",
      "outputs": [{"internalType": "uint256[]", "name": "", "type": "uint256[]"}],
      "stateMutability": "view",
      "type": "function"
    }
  ]
  ''';

  static const String _marketplaceABI = '''
  [
    {
      "inputs": [],
      "name": "fetchMarketItems",
      "outputs": [
        {
          "components": [
            {"internalType": "uint256", "name": "itemId", "type": "uint256"},
            {"internalType": "address", "name": "nftContract", "type": "address"},
            {"internalType": "uint256", "name": "tokenId", "type": "uint256"},
            {"internalType": "address", "name": "seller", "type": "address"},
            {"internalType": "address", "name": "owner", "type": "address"},
            {"internalType": "uint256", "name": "price", "type": "uint256"},
            {"internalType": "bool", "name": "sold", "type": "bool"},
            {"internalType": "bool", "name": "isAuction", "type": "bool"},
            {"internalType": "uint256", "name": "auctionEndTime", "type": "uint256"},
            {"internalType": "address", "name": "highestBidder", "type": "address"},
            {"internalType": "uint256", "name": "highestBid", "type": "uint256"}
          ],
          "internalType": "struct SpringTenMarketplace.MarketItem",
          "name": "",
          "type": "tuple[]"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [{"internalType": "address", "name": "nftContract", "type": "address"}, {"internalType": "uint256", "name": "tokenId", "type": "uint256"}, {"internalType": "uint256", "name": "price", "type": "uint256"}, {"internalType": "bool", "name": "isAuction", "type": "bool"}, {"internalType": "uint256", "name": "auctionDuration", "type": "uint256"}],
      "name": "createMarketItem",
      "outputs": [],
      "stateMutability": "payable",
      "type": "function"
    },
    {
      "inputs": [{"internalType": "uint256", "name": "itemId", "type": "uint256"}],
      "name": "createMarketSale",
      "outputs": [],
      "stateMutability": "payable",
      "type": "function"
    }
  ]
  ''';

  // Get contract addresses
  static Map<String, String> getContractAddresses() {
    return {
      'token': _tokenAddress,
      'nft': _nftAddress,
      'marketplace': _marketplaceAddress,
    };
  }

  // Get contract ABIs
  static Map<String, String> getContractABIs() {
    return {
      'token': _tokenABI,
      'nft': _nftABI,
      'marketplace': _marketplaceABI,
    };
  }

  // Get RPC URL
  static String getRpcUrl() => _rpcUrl;

  // Simulate contract calls (in a real app, you'd use web3dart or similar)
  static Future<Map<String, dynamic>> callContract({
    required String contractAddress,
    required String abi,
    required String functionName,
    required List<dynamic> parameters,
  }) async {
    // This is a simplified simulation
    // In a real app, you'd use web3dart to make actual contract calls
    
    try {
      // Simulate API call to local Hardhat node
      final response = await http.post(
        Uri.parse(_rpcUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'jsonrpc': '2.0',
          'method': 'eth_call',
          'params': [
            {
              'to': contractAddress,
              'data': '0x', // Simplified - would contain encoded function call
            },
            'latest'
          ],
          'id': 1,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'error': 'RPC call failed'};
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // Get token info
  static Future<TokenInfo> getTokenInfo() async {
    // Simulate getting token info
    return TokenInfo(
      name: 'SpringTen Token',
      symbol: 'SPRING',
      totalSupply: '100000000',
      contractAddress: _tokenAddress,
    );
  }

  // Get NFT collection info
  static Future<NFTCollectionInfo> getNFTCollectionInfo() async {
    // Simulate getting NFT collection info
    return NFTCollectionInfo(
      name: 'SpringTen Collection',
      symbol: 'SPRINGNFT',
      totalSupply: '0',
      maxSupply: '10000',
      mintPrice: '0.01',
      contractAddress: _nftAddress,
      isActive: true,
    );
  }

  // Get marketplace items
  static Future<List<MarketplaceItem>> getMarketplaceItems() async {
    // Simulate getting marketplace items
    return [
      MarketplaceItem(
        itemId: 1,
        nftContract: _nftAddress,
        tokenId: 1,
        seller: '0x123...',
        price: '0.1',
        isAuction: false,
        imageUrl: 'https://i.seadn.io/gs/2fmyry3prsd1/0x394e3d3044fc89fcdd966d3cb35ac0b32b0cda91/0?w=500&auto=format',
        name: 'SpringTen NFT #1',
      ),
      MarketplaceItem(
        itemId: 2,
        nftContract: _nftAddress,
        tokenId: 2,
        seller: '0x456...',
        price: '0.05',
        isAuction: true,
        imageUrl: 'https://i.seadn.io/gs/2fmyry3prsd1/0x23581767a106ae21c074b2276d3cb35ac0b32b0cda91/0?w=500&auto=format',
        name: 'SpringTen NFT #2',
      ),
    ];
  }
}

// Data models
class TokenInfo {
  final String name;
  final String symbol;
  final String totalSupply;
  final String contractAddress;

  TokenInfo({
    required this.name,
    required this.symbol,
    required this.totalSupply,
    required this.contractAddress,
  });
}

class NFTCollectionInfo {
  final String name;
  final String symbol;
  final String totalSupply;
  final String maxSupply;
  final String mintPrice;
  final String contractAddress;
  final bool isActive;

  NFTCollectionInfo({
    required this.name,
    required this.symbol,
    required this.totalSupply,
    required this.maxSupply,
    required this.mintPrice,
    required this.contractAddress,
    required this.isActive,
  });
}

class MarketplaceItem {
  final int itemId;
  final String nftContract;
  final int tokenId;
  final String seller;
  final String price;
  final bool isAuction;
  final String imageUrl;
  final String name;

  MarketplaceItem({
    required this.itemId,
    required this.nftContract,
    required this.tokenId,
    required this.seller,
    required this.price,
    required this.isAuction,
    required this.imageUrl,
    required this.name,
  });
}
