import 'package:flutter/material.dart';
import 'package:trading_demo_app/core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/price_formatter.dart';

// Pre-built const decorations — allocated once at startup.
// The badge rebuilds on every 500 ms tick; keeping these as constants
// avoids any heap allocation in build().
const _kGainDecoration = BoxDecoration(
  color: AppColors.gainBackground,
  borderRadius: BorderRadius.all(Radius.circular(AppConstants.chipRadius)),
);
const _kLossDecoration = BoxDecoration(
  color: AppColors.lossBackground,
  borderRadius: BorderRadius.all(Radius.circular(AppConstants.chipRadius)),
);

// Small pill showing a percentage change with an optional arrow icon.
class PriceChangeBadge extends StatelessWidget {
  const PriceChangeBadge({
    super.key,
    required this.percentChange,
    this.showIcon = true,
    this.fontSize,
    this.padding,
  });

  final double percentChange;
  final bool showIcon;
  final double? fontSize;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final isGain = percentChange >= 0;
    final decoration = isGain ? _kGainDecoration : _kLossDecoration;
    final color = isGain ? AppColors.gainColor : AppColors.lossColor;
    final icon = isGain ? Icons.arrow_drop_up : Icons.arrow_drop_down;

    return DecoratedBox(
      decoration: decoration,
      child: Padding(
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIcon) Icon(icon, color: color, size: 16),
            Text(
              PriceFormatter.formatPercent(percentChange),
              style: AppTextStyles.labelMedium.copyWith(
                color: color,
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
