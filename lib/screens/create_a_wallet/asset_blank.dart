import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:springten/providers/auth_provider.dart';
import 'package:springten/providers/wallet_provider.dart';
import 'package:springten/providers/crypto_provider.dart';
import 'package:springten/providers/asset_viewmodel.dart';
import 'package:springten/providers/realtime_price_provider.dart';
import 'package:springten/providers/realtime_money_provider.dart';
import 'package:springten/screens/create_a_wallet/token_detail_screen.dart';

class AssetBlank extends ConsumerStatefulWidget {
  const AssetBlank({super.key});

  @override
  ConsumerState<AssetBlank> createState() => _AssetBlankState();
}

class _AssetBlankState extends ConsumerState<AssetBlank>
    with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  bool _isEditingName = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Initialize auth state from storage first
      ref.read(authProvider.notifier).initializeFromStorage();
      ref.read(assetViewModelProvider.notifier).loadWalletData();
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _showEthDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TokenDetailScreen(
          tokenSymbol: 'ETH',
          tokenName: 'Ethereum',
          price: 2500.0, // Mock ETH price
          change24h: 2.5, // Mock change
          imageUrl: '',
        ),
      ),
    );
  }

  void _showTokenDetails(BuildContext context, dynamic crypto) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TokenDetailScreen(
          tokenSymbol: crypto.symbol,
          tokenName: crypto.name,
          price: crypto.price,
          change24h: crypto.change24h,
          imageUrl: '', // We can add image URLs later
        ),
      ),
    );
  }

  void _startEditingName() {
    setState(() {
      _isEditingName = true;
      _nameController.text = ref.read(authProvider).user?.fullName ?? 'Wallet User';
    });
  }

  void _saveName() async {
    if (_nameController.text.trim().isNotEmpty) {
      // Update the user name in the auth provider
      await ref.read(authProvider.notifier).updateUserName(_nameController.text.trim());
      setState(() {
        _isEditingName = false;
      });
    }
  }

  void _cancelEditing() {
    setState(() {
      _isEditingName = false;
      _nameController.clear();
    });
  }


  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final walletState = ref.watch(walletProvider);
    final cryptoState = ref.watch(cryptoProvider);
    final realtimePrices = ref.watch(pricesProvider);
    final ethPrice = ref.watch(ethPriceProvider);
    final realtimeBalance = ref.watch(currentBalanceProvider);
    
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Logo on the left
                    Image.asset(
                      'lib/images/logo.png',
                      height: 22,
                    ),
                    
                    // Spacer to push everything else to the right
                    const Spacer(),
                    
                    // Network info - ultra compact Ethereum app bar
                    Flexible(
                      child: GestureDetector(
                        onTap: () => _showEthDetails(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2B35),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue.withOpacity(0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Image.asset(
                                    'lib/images/eth.png',
                                    width: 12,
                                    height: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                'ETH',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 3),
                              Container(
                                width: 3,
                                height: 3,
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 2),
                              const Icon(
                                Icons.arrow_drop_down,
                                size: 12,
                                color: Colors.white70,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 8),
                    
                    // Action buttons
                    IconButton(
                      onPressed: () => ref.read(assetViewModelProvider.notifier).refreshWalletData(),
                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.grey,
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    
                    const SizedBox(width: 4),
                    
                    IconButton(
                      onPressed: () => ref.read(assetViewModelProvider.notifier).logout(context),
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.grey,
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    
                    const SizedBox(width: 4),
                    
                    IconButton(
                      onPressed: (){},
                      icon: const Icon(
                        Icons.qr_code_scanner,
                        color: Colors.grey,
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2B35),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade800),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Total Asset Value',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          if (realtimeBalance != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.circle, color: Colors.green, size: 8),
                                  SizedBox(width: 4),
                                  Text(
                                    'LIVE',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      realtimeBalance != null
                          ? Text(
                              '\$${realtimeBalance.usdValue.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                          : walletState.isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  '\$${walletState.balance?.balance ?? '0.0'}',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            realtimeBalance != null
                                ? '${realtimeBalance.ethBalance.toStringAsFixed(4)} ETH'
                                : walletState.error != null 
                                    ? 'Error loading balance'
                                    : '${walletState.balance?.balanceEth ?? '0.0'} ETH',
                            style: TextStyle(
                              color: realtimeBalance != null 
                                  ? Colors.greenAccent
                                  : walletState.error != null ? Colors.red : Colors.greenAccent,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (ethPrice != null && walletState.error == null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: ethPrice.isPositive ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                ethPrice.formattedChange,
                                style: TextStyle(
                                  color: ethPrice.isPositive ? Colors.green : Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const Divider(),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade900,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Text(
                                  "Address",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Image.asset('lib/images/eth.png'),
                                const SizedBox(width: 4),
                                Text(
                                  ref.read(assetViewModelProvider.notifier).formatAddress(authState.user?.walletAddress ?? 'No address'),
                                  style: const TextStyle(color: Colors.blueAccent),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => ref.read(assetViewModelProvider.notifier).copyAddress(authState.user?.walletAddress ?? '', context),
                            child: const Icon(Icons.copy, color: Colors.white54, size: 16),
                          ),
                        ],
                      ),
                      
                      const Divider(),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.emoji_emotions, color: Colors.yellow),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _isEditingName
                                ? TextField(
                                    controller: _nameController,
                                    style: const TextStyle(color: Colors.white, fontSize: 16),
                                    decoration: const InputDecoration(
                                      hintText: 'Enter your name',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    autofocus: true,
                                    onSubmitted: (_) => _saveName(),
                                  )
                                : Text(
                                    authState.user?.fullName ?? 'Wallet User',
                                    style: const TextStyle(color: Colors.white, fontSize: 16),
                                  ),
                          ),
                          const SizedBox(width: 8),
                          _isEditingName
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: _saveName,
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.green,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: _cancelEditing,
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                )
                              : GestureDetector(
                                  onTap: _startEditingName,
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white54,
                                    size: 16,
                                  ),
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Token Balance",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (cryptoState.lastUpdated != null)
                      Text(
                        'Updated ${ref.read(assetViewModelProvider.notifier).formatTime(cryptoState.lastUpdated!)}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      '${cryptoState.cryptos.length} stored',
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () => ref.read(assetViewModelProvider.notifier).refreshCryptoData(),
                      icon: const Icon(Icons.refresh, size: 16, color: Colors.grey),
                      label: const Text(
                        'Refresh',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
              // Real-time crypto data
              if (realtimePrices.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                )
              else ...[
                // Status indicator
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: Colors.blue,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Live market data',
                        style: TextStyle(
                          color: Colors.blue[300],
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          ref.read(realtimePriceProvider.notifier).refreshPrices();
                        },
                        child: Icon(
                          Icons.refresh,
                          color: Colors.blue[300],
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                ...realtimePrices.values.take(6).map((crypto) => Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: () => _showTokenDetails(context, crypto),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.grey[800],
                              child: Text(
                                crypto.symbol.substring(0, 1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  crypto.symbol,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  crypto.name,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              crypto.formattedPrice,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: crypto.isPositive ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                crypto.formattedChange,
                                style: TextStyle(
                                  color: crypto.isPositive ? Colors.green : Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )),
              ],
              ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}