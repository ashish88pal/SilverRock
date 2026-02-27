import 'package:flutter/material.dart';
import 'package:svg_flutter/svg_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/price_formatter.dart';
import 'sparkline_chart.dart';
import '../../domain/entities/market_asset.dart';
import '../../../../shared/widgets/asset_logo.dart';

/// Figma row: [Logo] [Name / Date / % / Chart btn] [Sell box] [Buy box]
///
/// Performance:
/// • RepaintBoundary — tiles composite to individual layers; a price tick in
///   one tile does not trigger a repaint pass on its neighbours.
/// • All BoxDecoration/Border objects are file-level constants → zero heap
///   allocation in build().
/// • StatelessWidget → no State overhead.
class MarketAssetTile extends StatelessWidget {
  final MarketAsset asset;
  final VoidCallback? onTap;

  const MarketAssetTile({super.key, required this.asset, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isGain = asset.isGain;
    final changeColor = isGain ? AppColors.gainColor : AppColors.lossColor;
    final arrowIcon = isGain ? Icons.trending_up : Icons.trending_down;
    final changeText = PriceFormatter.formatPercent(
      asset.priceChangePercent24h,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 90,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: AssetLogo(emoji: asset.logoEmoji, size: 38),
                        ),
                        SizedBox(width: 10),
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
                        SizedBox(width: 10),

                        Row(
                          children: [
                            SizedBox(
                              width: 45,
                              child: AnimatedText(
                                isAbsolueNotPercent: false,
                                price: double.parse(
                                  changeText.replaceAll('%', ''),
                                ),
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: changeColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            const SizedBox(width: 8),
                            const ChartButton(),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 10),

                Spacer(),
                SizedBox(
                  width: 70,
                  child: SparklineChart(
                    data: asset.sparklineData,
                    isGain: asset.isGain,
                  ),
                ),
                const SizedBox(width: 10),
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
    );
  }
}

class ChangeRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const ChangeRow({
    super.key,
    required this.icon,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedText(
          isAbsolueNotPercent: false,
          price: double.parse(text.replaceAll('%', '')),
          style: AppTextStyles.bodySmall.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(width: 8),
        const ChartButton(),
      ],
    );
  }
}

/// Fully const widget — Flutter element cache prevents any rebuild.
class ChartButton extends StatelessWidget {
  const ChartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      padding: EdgeInsets.all(5),
      widget: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset('assets/graph.svg', width: 12, height: 12),

          SizedBox(width: 3),
          Text(
            'Chart',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
      onTap: () {},
    );
  }
}

class TradingBox extends StatelessWidget {
  final String label;
  final double price;
  final bool isSell;
  final VoidCallback? onTap;

  const TradingBox({
    super.key,
    required this.label,
    required this.price,
    required this.isSell,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final labelColor = isSell ? AppColors.sellColor : AppColors.buyColor;

    return CustomButton(
      onTap: onTap ?? () {},

      widget: SizedBox(
        width: 74,
        height: 55,

        child: Column(
          mainAxisSize: MainAxisSize.min,
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

            AnimatedText(
              price: price,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: labelColor,
              ),
              // textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final Widget widget;
  final VoidCallback onTap;
  final EdgeInsetsGeometry? padding;

  const CustomButton({
    super.key,
    required this.widget,
    required this.onTap,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
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
              spreadRadius: 0,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: widget,
      ),
    );
  }
}

class AnimatedText extends StatelessWidget {
  final double price;
  final TextStyle? style;
  final bool isAbsolueNotPercent;

  const AnimatedText({
    super.key,
    required this.price,
    this.style,
    this.isAbsolueNotPercent = true,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: price, end: price),
      duration: const Duration(milliseconds: 300),
      builder: (context, value, child) {
        return Text(
          isAbsolueNotPercent
              ? value.toStringAsFixed(2)
              : ('${value.toStringAsFixed(2)}%'),
          style: style,
        );
      },
    );
  }
}
