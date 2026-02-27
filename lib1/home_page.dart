import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_text_styles.dart';
import 'features/market/presentation/pages/market_page.dart';

// ── Pre-allocated decorations — zero heap churn on tab changes ────────────

// CenterNavItem gradient bubble — the gradient and shadow are the same on
// every render; pre-baking avoids withValues() allocation per tab tap.

// CenterNavItem InkWell splash — pre-baked, not withValues() per tap.
// white 20 %

// ── HomePage ──────────────────────────────────────────────────────────────

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 4; // Start on Market Watch (centre tab)

  // Pages are const-constructible — allocated once, kept alive by IndexedStack.
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
        child: CircleAvatar(
          radius: 32,
          backgroundColor: AppColors.navBackground,
          child: Icon(
            Icons.home,
            color: _currentIndex == 4 ? AppColors.surface : AppColors.textMuted,
          ),
        ),
        onTap: () {
          setState(() {
            _currentIndex = 4; // Navigate to Market Watch when FAB is tapped
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: [
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
        onTap: (index) => setState(() => _currentIndex = index),
        //other params
      ),

      // HomeBottomNavBar(
      //   currentIndex: _currentIndex,
      //   onIndexChanged: (i) => setState(() => _currentIndex = i),
      // ),
    );
  }
}

// ── Placeholder Page ──────────────────────────────────────────────────────

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
          style: const TextStyle(
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
