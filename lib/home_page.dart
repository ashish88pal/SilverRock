import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:trading_demo_app/core/constants/app_constants.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_text_styles.dart';
import 'features/market/presentation/pages/market_page.dart';

// Shell that wraps all top-level tab pages.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Market Watch (index 4) is the default tab.
  int _currentIndex = 4;

  // Pages are const so Flutter reuses the same element across tab switches.
  static const _pages = [
    PlaceholderPage(icon: Icons.star_border, label: 'My Favorites'),
    PlaceholderPage(icon: Icons.receipt_long_outlined, label: 'Order'),
    PlaceholderPage(icon: Icons.candlestick_chart_outlined, label: 'Positions'),
    PlaceholderPage(
      icon: Icons.account_balance_wallet_outlined,
      label: 'Wallet',
    ),
    MarketPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _currentIndex, children: _pages),
      floatingActionButton: GestureDetector(
        onTap: () => setState(() => _currentIndex = 4),
        child: CircleAvatar(
          radius: AppConstants.cardRadius * 2,
          backgroundColor: AppColors.navBackground,
          child: Icon(
            Icons.home,
            color: _currentIndex == 4 ? AppColors.surface : AppColors.textMuted,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: const [
          IconData(0xe900, fontFamily: 'CustomIcons'),
          IconData(0xe903, fontFamily: 'CustomIcons'),
          IconData(0xe901, fontFamily: 'CustomIcons'),
          IconData(0xe902, fontFamily: 'CustomIcons'),
        ],
        activeIndex: _currentIndex,
        activeColor: AppColors.surface,
        inactiveColor: AppColors.textMuted,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        backgroundColor: AppColors.navBackground,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

// Temporary placeholder used for tabs that are not yet implemented.
class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: AppColors.textMuted),
            const SizedBox(height: 16),
            Text('$label Coming Soon', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 8),
            const Text(
              'This section is under construction',
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
