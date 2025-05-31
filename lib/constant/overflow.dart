import 'package:flutter/material.dart';

class OverflowConstants {
  final double screenHeight;
  final double screenWidth;
  final bool isPortrait;
  final bool isLandscape;
  final bool isSmallScreen;
  final bool isLargeScreen;
  final bool isTablet;
  final bool isMobile;
  final bool isDarkMode;
  final bool isLightMode;
  final double cardWidth;

  OverflowConstants({
    required this.screenHeight,
    required this.screenWidth,
    required this.isPortrait,
    required this.isLandscape,
    required this.isSmallScreen,
    required this.isLargeScreen,
    required this.isTablet,
    required this.isMobile,
    required this.isDarkMode,
    required this.isLightMode,
    required this.cardWidth,
  });

  static OverflowConstants of(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final isSmallScreen = screenWidth < 600;
    final isLargeScreen = screenWidth >= 600;
    final isTablet = screenWidth >= 600 && screenHeight >= 600;
    final isMobile = screenWidth < 600;
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final isLightMode = MediaQuery.of(context).platformBrightness == Brightness.light;

    late double cardWidth;
    if (isTablet && isLandscape) {
      cardWidth = screenWidth * 0.4;
    } else if (isMobile && isPortrait) {
      cardWidth = screenWidth * 0.99;
    } else {
      cardWidth = screenWidth * 0.6;
    }

    return OverflowConstants(
      screenHeight: screenHeight,
      screenWidth: screenWidth,
      isPortrait: isPortrait,
      isLandscape: isLandscape,
      isSmallScreen: isSmallScreen,
      isLargeScreen: isLargeScreen,
      isTablet: isTablet,
      isMobile: isMobile,
      isDarkMode: isDarkMode,
      isLightMode: isLightMode,
      cardWidth: cardWidth,
    );
  }
}