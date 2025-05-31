import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class AssetBlank extends StatefulWidget {
  const AssetBlank({super.key});

  @override
  State<AssetBlank> createState() => _AssetBlankState();
}

class _AssetBlankState extends State<AssetBlank> {
  late StreamController<String> _balanceController;
  @override
  void initState() {
  super.initState();
  _balanceController = StreamController<String>();
  final random = Random();
  // Simulate random balance updates
  Timer.periodic(const Duration(seconds: 9), (timer) {
    double price = random.nextDouble() * 10000; // Random price between 0 and 10,000
    _balanceController.add('\$${price.toStringAsFixed(2)}');
  });
}

  void dispose() {
    _balanceController.close();
    super.dispose();
  }
  Widget build(BuildContext context) {
    
          return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 30,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Image.asset(
          'lib/images/logo.png',
          fit: BoxFit.contain,
        ),
      ),      
        centerTitle: true,
        title: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF2A2B35),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          margin: EdgeInsets.all(8),
          child: Row(
            children: [
              Image.asset(
                'lib/images/eth.png',
                /*width: 18,
                height: 20,*/
              ),
              const SizedBox(width: 4),
              const Text(
                ' Ethereum Main Network',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                overflow: TextOverflow.ellipsis, // Prevent text overflow
              ),
              Expanded( 
                child: DropdownButton<String>(
                  isExpanded: true, 
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  underline: const SizedBox(),
                  items: <String>[
                    'Ethereum Main Network',
                    'Binance Smart Chain',
                    'Polygon'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        overflow: TextOverflow.ellipsis, // Prevent overflow in dropdown
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    // Handle network change
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
            onPressed: () {
              // Handle notifications
            },
          ),
          
        ],
      ),
      //BODY!
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Asset Value
            Column(
              children: [
                StreamBuilder<String>(
              stream: _balanceController.stream,
              initialData: '\$0.00',
              builder: (context, snapshot) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Asset Value',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.data ?? '\$0.00',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              },
            ),
              ],
            ),
            const SizedBox(height: 40),
            
            // Address Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2B35),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.yellow,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        'U',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Address',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'user09087021',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, color: Colors.grey),
                    onPressed: () {
                      Clipboard.setData(const ClipboardData(text: 'user09087021'));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Address copied to clipboard')),
                      );
                    },
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Token Balance Section
            const Text(
              'Token Balance',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            // Token Items
            _buildTokenItem('0 Staked', Icons.account_balance_wallet),
            const SizedBox(height: 12),
            _buildTokenItem('0 Staked', Icons.account_balance_wallet),
            
            const Spacer(),
            
            // Bottom Navigation
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildBottomNavItem(Icons.account_balance_wallet, 'Wallet', true),
                  _buildBottomNavItem(Icons.access_time, 'History', false),
                  _buildBottomNavItem(Icons.swap_horiz, 'Swap', false),
                  _buildBottomNavItem(Icons.grid_view, 'DApps', false),
                  _buildBottomNavItem(Icons.settings, 'Settings', false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTokenItem(String amount, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2B35),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.grey,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              amount,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: isSelected ? Colors.white : Colors.grey,
            size: 24,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.blue : Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );   
    
  }
}