import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:springten/screens/create_a_wallet/asset_blank.dart';
import 'package:springten/screens/pages/d_app_screen.dart';
import 'package:springten/screens/pages/setting_screen.dart';
import 'package:springten/screens/pages/swap_screen.dart';
import 'package:springten/screens/pages/transaction_history_screen.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with TickerProviderStateMixin {
  int currentIndex = 0;
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
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  final List<Widget> pages = [
    const AssetBlank(),
    // Add other pages here when you create them
    const TransactionHistoryScreen(),
    const SwapScreen(),
    const DAppScreen(),
    const SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: pages.isNotEmpty && currentIndex < pages.length 
              ? pages[currentIndex] 
              : const Center(child: Text('Page not found', style: TextStyle(color: Colors.white))),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        //color: Colors.grey[600],
        height: 70, // Increased height
        padding: EdgeInsets.zero, // Remove default padding
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBottomNavItem(Icons.account_balance_wallet, 'Wallet', currentIndex == 0, 0),
            _buildBottomNavItem(Icons.history, 'Transactions', currentIndex == 1, 1),
            _buildBottomNavItem(Icons.swap_vert, 'Swap', currentIndex == 2, 2),
            _buildBottomNavItem(Icons.grid_view, 'DApps', currentIndex == 3, 3),
            _buildBottomNavItem(Icons.settings, 'Settings', currentIndex == 4, 4),
          ],
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    // Safety check to prevent range errors
    print('Tab tapped: $index, pages length: ${pages.length}, currentIndex: $currentIndex');
    if (index >= 0 && index < pages.length && index != currentIndex) {
      setState(() {
        currentIndex = index;
      });
      // Restart animation for page transition
      _animationController.reset();
      _animationController.forward();
    }
  }

  Widget _buildBottomNavItem(IconData icon, String label, bool isSelected, int index) {
    return Expanded(
      child: InkWell(
        onTap: () => onTabTapped(index),
        child: Container(
          height: 90, // Match the BottomAppBar height
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(6), // Reduced padding
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: isSelected ? Colors.white : Colors.grey,
                  size: 18, // Reduced icon size
                ),
              ),
              const SizedBox(height: 2), // Reduced spacing
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.blue : Colors.grey,
                  fontSize: 9, // Reduced font size
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}