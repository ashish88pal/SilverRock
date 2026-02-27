import 'package:flutter/material.dart';
import 'package:svg_flutter/svg_flutter.dart';
import 'package:trading_demo_app/core/constants/app_constants.dart';
import '../../../../core/constants/asset_constants.dart';
import '../../../../core/constants/ui_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

// The gradient header area of the market page: top bar + category tabs.
class MarketGradientHeader extends StatefulWidget {
  const MarketGradientHeader({
    super.key,
    required this.selectedIndex,
    required this.onCategorySelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onCategorySelected;

  @override
  State<MarketGradientHeader> createState() => MarketGradientHeaderState();
}

class MarketGradientHeaderState extends State<MarketGradientHeader>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: kMarketCategoryTabs.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: AppColors.headerGradient),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const MarketTopBar(),
            const SizedBox(height: 12),
            MarketCategoryTabs(
              controller: _tabController,
              selectedIndex: widget.selectedIndex,
              onCategorySelected: widget.onCategorySelected,
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

// Top bar showing the page title, wallet balance chip, and notification bell.
class MarketTopBar extends StatelessWidget {
  const MarketTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {},
            child: const Icon(Icons.menu, color: Colors.black, size: 24),
          ),
          const SizedBox(width: 12),
          Text(
            'Market Watch',
            style: AppTextStyles.titleMedium.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const Spacer(),
          // Wallet balance chip with gradient border
          Container(
            // height: 66.0,
            decoration: kBalanceOuterDecoration,
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.smallPadding / 2),
              child: Container(
                padding: EdgeInsets.all(AppConstants.smallPadding),
                decoration: kBalanceInnerDecoration,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/wallet.svg',
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      kInitialCashBalance.toString(),
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Notification bell with badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: SvgPicture.asset(
                  'assets/bell.svg',
                  width: 40,
                  height: 40,
                ),
              ),
              Positioned(
                right: 2,
                top: -2,
                child: DecoratedBox(
                  decoration: kNotifBadgeDecoration,
                  child: Padding(
                    padding: EdgeInsets.all(3),
                    child: Text(
                      '10',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Image-based category tabs (Indian Market, International, etc.).
class MarketCategoryTabs extends StatefulWidget {
  const MarketCategoryTabs({
    super.key,
    required this.controller,
    required this.selectedIndex,
    required this.onCategorySelected,
  });

  final TabController controller;
  final int selectedIndex;
  final ValueChanged<int> onCategorySelected;

  @override
  State<MarketCategoryTabs> createState() => MarketCategoryTabsState();
}

class MarketCategoryTabsState extends State<MarketCategoryTabs> {
  @override
  Widget build(BuildContext context) {
    return TabBar(
      onTap: (index) {
        widget.onCategorySelected(index);
        setState(() {});
      },
      controller: widget.controller,
      tabs: kMarketCategoryTabs.asMap().entries.map((entry) {
        final isSelected = entry.key == widget.controller.index;
        final tab = entry.value;
        return Tab(
          height: 70,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                height: isSelected ? 55 : 40,
                child: Image.asset(tab.imagePath),
              ),
              Text(
                tab.label,
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 9,
                  color: isSelected
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      labelColor: AppColors.textPrimary,
      unselectedLabelColor: AppColors.textSecondary,
      indicatorColor: AppColors.textPrimary,
      indicatorWeight: 4,
      indicatorSize: TabBarIndicatorSize.tab,
      dividerColor: Colors.transparent,
      tabAlignment: TabAlignment.fill,
      padding: EdgeInsets.zero,
      labelPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}

// Text-based sub-tabs (NSE FUTURES, NSE OPTION, etc.).
// The active tab shows a gradient pill; inactive tabs show plain text.
class MarketSubTabs extends StatefulWidget {
  const MarketSubTabs({
    super.key,
    required this.controller,
    required this.tabs,
  });

  final TabController controller;
  final List<String> tabs;

  @override
  State<MarketSubTabs> createState() => MarketSubTabsState();
}

class MarketSubTabsState extends State<MarketSubTabs> {
  @override
  Widget build(BuildContext context) {
    return TabBar(
      onTap: (_) => setState(() {}),
      controller: widget.controller,
      tabs: widget.tabs.asMap().entries.map((entry) {
        final isActive = entry.key == widget.controller.index;
        return Tab(
          child: isActive
              ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.smallPadding,
                    vertical: AppConstants.smallPadding / 2,
                  ),
                  decoration: const BoxDecoration(
                    gradient: AppColors.tabGradient,
                    borderRadius: BorderRadius.all(
                      Radius.circular(AppConstants.chipRadius),
                    ),
                  ),
                  child: Text(
                    entry.value,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                )
              : Text(entry.value, style: AppTextStyles.bodySmall),
        );
      }).toList(),
      indicatorColor: Colors.transparent,
      indicatorWeight: 3,
      indicatorSize: TabBarIndicatorSize.tab,
      dividerColor: AppColors.divider,
      isScrollable: true,
      tabAlignment: TabAlignment.center,
      padding: EdgeInsets.zero,
    );
  }
}

// Search text field styled to match the market page.
class MarketSearchBar extends StatelessWidget {
  const MarketSearchBar({super.key, required this.onQueryChanged});

  final ValueChanged<String> onQueryChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: DecoratedBox(
        decoration: kSearchBoxDecoration,
        child: SizedBox(
          height: 50,
          child: TextField(
            onChanged: onQueryChanged,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: 'Search Nse Futures',
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textMuted,
              ),
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.textMuted,
                size: 18,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
