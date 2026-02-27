import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/asset_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/injection/injection_container.dart';
import '../../domain/entities/market_asset.dart';
import '../bloc/market_bloc.dart';
import '../bloc/market_event.dart';
import '../bloc/market_state.dart';
import '../widgets/market_asset_tile.dart';
import '../widgets/market_header_widgets.dart';

// Entry point for the market feature. Provides the MarketBloc and renders
// MarketView below it.
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

// Stateful because it owns two TabControllers that need a vsync.
class MarketView extends StatefulWidget {
  const MarketView({super.key});

  @override
  State<MarketView> createState() => _MarketViewState();
}

class _MarketViewState extends State<MarketView>
    with SingleTickerProviderStateMixin {
  int _selectedCategoryIndex = 0;
  late final TabController _subTabController;

  @override
  void initState() {
    super.initState();
    _subTabController = TabController(
      length: kMarketSubTabs.length,
      vsync: this,
    );
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
            selectedIndex: _selectedCategoryIndex,
            onCategorySelected: (index) {
              setState(() => _selectedCategoryIndex = index);
              _subTabController.animateTo(0);
            },
          ),
          Expanded(
            child: Column(
              children: [
                MarketSubTabs(
                  controller: _subTabController,
                  tabs: kMarketSubTabs,
                ),
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

// Live asset list — rebuilds on every price tick so each tile receives
// fresh data. The ListView.builder call itself is O(1); GPU repaints are
// isolated per tile by RepaintBoundary inside MarketAssetTile.
class MarketAssetList extends StatelessWidget {
  const MarketAssetList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<MarketBloc, MarketState, List<MarketAsset>>(
      selector: (state) => state is MarketLoaded ? state.filteredAssets : [],
      builder: (context, assets) {
        if (assets.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        return ColoredBox(
          color: Colors.white,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: assets.length,
            itemBuilder: (_, index) => MarketAssetTile(
              key: ValueKey(assets[index].id),
              asset: assets[index],
              onTap: () {},
            ),
          ),
        );
      },
    );
  }
}
