import 'package:flutter/material.dart';
import 'package:springten/screens/create_a_wallet/asset_blank.dart';
import 'package:springten/screens/pages/d_app_screen.dart';
import 'package:springten/screens/pages/history.dart';
import 'package:springten/screens/pages/setting_screen.dart';
import 'package:springten/screens/pages/swap_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  
  final List<Widget> pages = [
    const AssetBlank(),
    // Add other pages here when you create them
    const History(),
    const SwapScreen(),
    const DAppScreen(),
    const SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomAppBar(
        //color: Colors.grey[600],
        height: 70, // Increased height
        padding: EdgeInsets.zero, // Remove default padding
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBottomNavItem(Icons.account_balance_wallet, 'Wallet', currentIndex == 0, 0),
            _buildBottomNavItem(Icons.access_time, 'History', currentIndex == 1, 1),
            _buildBottomNavItem(Icons.swap_horiz, 'Swap', currentIndex == 2, 2),
            _buildBottomNavItem(Icons.grid_view, 'DApps', currentIndex == 3, 3),
            _buildBottomNavItem(Icons.settings, 'Settings', currentIndex == 4, 4),
          ],
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
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