import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:svg_flutter/svg_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/injection/injection_container.dart';
import '../../domain/entities/market_asset.dart';
import '../bloc/market_bloc.dart';
import '../bloc/market_event.dart';
import '../bloc/market_state.dart';
import '../widgets/market_asset_tile.dart';

// Pre-allocated decorations — zero heap churn in build().
const _kNotifBadgeDecoration = BoxDecoration(
  color: Colors.red,
  shape: BoxShape.circle,
);
const _kSearchBoxDecoration = BoxDecoration(
  color: AppColors.cardBackground,
  borderRadius: BorderRadius.all(Radius.circular(8)),
  border: Border.fromBorderSide(BorderSide(color: AppColors.cardBorder)),
);
// white 30%
// white 15%

class MarketPage extends StatelessWidget {
  const MarketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MarketBloc>()..add(const MarketStarted()),
      child: const MarketView(),
    );
  }
}

class MarketView extends StatefulWidget {
  const MarketView({super.key});

  @override
  State<MarketView> createState() => MarketViewState();
}

class MarketViewState extends State<MarketView>
    with SingleTickerProviderStateMixin {
  int _selectedCategoryIndex = 0;
  late final TabController _subTabController;

  static const _categories = [
    (label: 'Indian Market', emoji: 'assets/ig.png'),
    (label: 'International', emoji: 'assets/int.png'),
    (label: 'Forex Futures', emoji: 'assets/forex.png'),
    (label: 'Crypto Futures', emoji: 'assets/crpto.png'),
  ];

  static const _subTabs = [
    'NSE FUTURES',
    'NSE OPTION',
    'MCX FUTURES',
    'MCX OPTIONS',
  ];

  @override
  void initState() {
    super.initState();
    _subTabController = TabController(length: _subTabs.length, vsync: this);
  }

  @override
  void dispose() {
    _subTabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          MarketGradientHeader(
            categories: _categories,
            selectedIndex: _selectedCategoryIndex,
            onCategorySelected: (index) {
              setState(() => _selectedCategoryIndex = index);
              _subTabController.animateTo(0);
            },
          ),
          Expanded(
            child: Column(
              children: [
                MarketSubTabs(controller: _subTabController, tabs: _subTabs),
                MarketSearchBar(
                  onQueryChanged: (q) => context.read<MarketBloc>().add(
                    MarketSearchQueryChanged(q),
                  ),
                ),
                const Expanded(child: MarketAssetList()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────

class MarketGradientHeader extends StatefulWidget {
  const MarketGradientHeader({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onCategorySelected,
  });

  final List<({String label, String emoji})> categories;
  final int selectedIndex;
  final ValueChanged<int> onCategorySelected;

  @override
  State<MarketGradientHeader> createState() => _MarketGradientHeaderState();
}

class _MarketGradientHeaderState extends State<MarketGradientHeader>
    with SingleTickerProviderStateMixin {
  late final TabController _categoryTabController;

  @override
  void initState() {
    super.initState();
    _categoryTabController = TabController(
      length: widget.categories.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _categoryTabController.dispose();
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
              controller: _categoryTabController,
              tabs: widget.categories,
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

// Source - https://stackoverflow.com/a/59964891
// Posted by Ankit Dubey, modified by community. See post 'Timeline' for change history
// Retrieved 2026-02-27, License - CC BY-SA 4.0

final kInnerDecoration = BoxDecoration(
  color: Colors.white,

  borderRadius: BorderRadius.circular(10),
);

final kGradientBoxDecoration = BoxDecoration(
  gradient: AppColors.tabGradient,
  border: Border(
    bottom: BorderSide(color: AppColors.headerGradientEnd, width: 5),
  ),
  borderRadius: BorderRadius.circular(15),
);

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
          const Text(
            'Market Watch',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const Spacer(),
          // Source - https://stackoverflow.com/a/59964891
          // Posted by Ankit Dubey, modified by community. See post 'Timeline' for change history
          // Retrieved 2026-02-27, License - CC BY-SA 4.0
          Container(
            height: 66.0,
            decoration: kGradientBoxDecoration,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
                decoration: kInnerDecoration,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/wallet.svg',
                      width: 25,
                      height: 25,
                    ),
                    // Text('🛒', style: TextStyle(fontSize: 14)),
                    SizedBox(width: 6),
                    Text(
                      '122200',
                      style: TextStyle(
                        fontSize: 20,
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
          Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: EdgeInsets.all(8),
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
                  decoration: _kNotifBadgeDecoration,
                  child: const Padding(
                    padding: EdgeInsets.all(3),
                    child: Text(
                      '10',
                      style: TextStyle(
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

class MarketCategoryTabs extends StatefulWidget {
  const MarketCategoryTabs({
    super.key,
    required this.controller,
    required this.tabs,
  });

  final TabController controller;
  final List<({String emoji, String label})> tabs;

  @override
  State<MarketCategoryTabs> createState() => _MarketCategoryTabsState();
}

class _MarketCategoryTabsState extends State<MarketCategoryTabs> {
  @override
  Widget build(BuildContext context) {
    return TabBar(
      onTap: (value) {
        setState(() {});
      },
      controller: widget.controller,
      tabs: widget.tabs
          .map(
            (t) => Tab(
              height: 75,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    height: widget.controller.index == widget.tabs.indexOf(t)
                        ? 55
                        : 40,
                    child: Image.asset(t.emoji),
                  ),

                  Text(
                    t.label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          widget.controller.index == widget.tabs.indexOf(t)
                          ? FontWeight.bold
                          : FontWeight.normal,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
      labelColor: AppColors.textPrimary,
      unselectedLabelColor: AppColors.textSecondary,
      indicatorColor: AppColors.textPrimary,
      indicatorWeight: 4,
      indicatorSize: TabBarIndicatorSize.tab,
      dividerColor: Colors.transparent,
      // isScrollable: true,
      tabAlignment: TabAlignment.fill,
      padding: EdgeInsets.zero,
      labelPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}

class MarketSubTabs extends StatefulWidget {
  const MarketSubTabs({
    super.key,
    required this.controller,
    required this.tabs,
  });

  final TabController controller;
  final List<String> tabs;

  @override
  State<MarketSubTabs> createState() => _MarketSubTabsState();
}

class _MarketSubTabsState extends State<MarketSubTabs> {
  @override
  Widget build(BuildContext context) {
    return TabBar(
      onTap: (value) => setState(() {}),
      controller: widget.controller,
      tabs: widget.tabs
          .map(
            (t) => Tab(
              child: widget.tabs.indexOf(t) == widget.controller.index
                  ? Container(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),

                      decoration: BoxDecoration(
                        gradient: AppColors.tabGradient,
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                      child: Text(
                        t,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                      ),
                    )
                  : Text(
                      t,
                      style: const TextStyle(
                        //
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
            ),
          )
          .toList(),
      // labelColor: AppColors.primary,
      // unselectedLabelColor: AppColors.textMuted,
      indicatorColor: Colors.transparent,
      indicatorWeight: 3,
      indicatorSize: TabBarIndicatorSize.tab,
      dividerColor: AppColors.divider,
      isScrollable: false,
      tabAlignment: TabAlignment.fill,
      padding: EdgeInsets.zero,
    );
  }
}

class MarketSearchBar extends StatelessWidget {
  const MarketSearchBar({super.key, required this.onQueryChanged});

  final ValueChanged<String> onQueryChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: DecoratedBox(
        decoration: _kSearchBoxDecoration,
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

// ── Asset List ────────────────────────────────────────────────────────────

class MarketAssetList extends StatelessWidget {
  const MarketAssetList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<MarketBloc, MarketState, List<MarketAsset>>(
      selector: (state) {
        if (state is MarketLoaded) return state.filteredAssets;
        return [];
      },
      builder: (context, assets) {
        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: assets.length,
          itemBuilder: (_, index) {
            return MarketAssetTile(asset: assets[index]);
          },
        );
      },
    );
  }
}
