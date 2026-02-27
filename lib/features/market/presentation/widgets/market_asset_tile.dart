import 'package:flutter/material.dart';
import 'package:svg_flutter/svg_flutter.dart';
import 'package:trading_demo_app/core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/price_formatter.dart';
import '../../../../shared/widgets/asset_logo.dart';
import '../../domain/entities/market_asset.dart';
import 'sparkline_chart.dart';

// One row in the market list. Contains logo, symbol, sparkline, and
// sell/buy price boxes.
//
// Performance notes:
// - RepaintBoundary isolates each tile; a price change in one tile does not
//   trigger a GPU repaint in its neighbours.
// - StatelessWidget — no State object overhead.
class MarketAssetTile extends StatelessWidget {
  const MarketAssetTile({super.key, required this.asset, this.onTap});

  final MarketAsset asset;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isGain = asset.isGain;
    final changeColor = isGain ? AppColors.gainColor : AppColors.lossColor;
    final arrowIcon = isGain ? Icons.trending_up : Icons.trending_down;
    final changeText = PriceFormatter.formatPercent(
      asset.priceChangePercent24h,
    );

    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 90,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Left column: logo + symbol + change
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Symbol row
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: AssetLogo(emoji: asset.logoEmoji, size: 38),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${asset.symbol} - JULY 25',
                                style: AppTextStyles.titleMedium.copyWith(
                                  fontSize: 13,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                '31-07-2025',
                                style: AppTextStyles.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Change row
                      Row(
                        children: [
                          SizedBox(
                            width: 38,
                            height: 35,
                            child: Center(
                              child: Icon(
                                arrowIcon,
                                color: changeColor,
                                size: 14,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ChangeValueText(
                            value: double.parse(changeText.replaceAll('%', '')),
                            color: changeColor,
                          ),
                          const SizedBox(width: 8),
                          const ChartButton(),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Sparkline
                  SizedBox(
                    width: 70,
                    child: SparklineChart(
                      data: asset.sparklineData,
                      isGain: asset.isGain,
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Sell / Buy boxes
                  TradingBox(
                    label: 'Sell',
                    price: asset.currentPrice - asset.currentPrice * 0.0003,
                    isSell: true,
                    onTap: () {},
                  ),
                  const SizedBox(width: 10),
                  TradingBox(
                    label: 'Buy',
                    price: asset.currentPrice + asset.currentPrice * 0.0003,
                    isSell: false,
                    onTap: onTap,
                  ),
                ],
              ),
            ),
            Divider(color: AppColors.cardBorder, height: 10, thickness: 1),
          ],
        ),
      ),
    );
  }
}

// Animates a numeric value over 300 ms when it changes.
class ChangeValueText extends StatelessWidget {
  const ChangeValueText({super.key, required this.value, required this.color});

  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 45,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: value, end: value),
        duration: const Duration(milliseconds: 300),
        builder: (_, v, _) => Text(
          '${v.toStringAsFixed(2)}%',
          style: AppTextStyles.bodySmall.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// Small "Chart" button with a graph icon.
class ChartButton extends StatelessWidget {
  const ChartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      padding: const EdgeInsets.all(5),
      onTap: () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset('assets/graph.svg', width: 12, height: 12),
          const SizedBox(width: 3),
          const Text(
            'Chart',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

// Sell or Buy price box.
class TradingBox extends StatelessWidget {
  const TradingBox({
    super.key,
    required this.label,
    required this.price,
    required this.isSell,
    this.onTap,
  });

  final String label;
  final double price;
  final bool isSell;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final labelColor = isSell ? AppColors.sellColor : AppColors.buyColor;

    return OutlinedButton(
      onTap: onTap ?? () {},
      child: SizedBox(
        width: 74,
        height: 55,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: labelColor,
              ),
            ),
            const SizedBox(height: 2),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: price, end: price),
              duration: const Duration(milliseconds: 300),
              builder: (_, v, _) => Text(
                v.toStringAsFixed(2),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: labelColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Shared card wrapper with shadow used by both _ChartButton and _TradingBox.
class OutlinedButton extends StatelessWidget {
  const OutlinedButton({
    super.key,
    required this.child,
    required this.onTap,
    this.padding,
  });

  final Widget child;
  final VoidCallback onTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.chipRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 2,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.blueGrey.shade50,
              blurRadius: 2,
              offset: Offset.zero,
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
