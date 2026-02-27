import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/price_formatter.dart';

// Pre-baked const decorations for the two badge variants — allocated once at
// class-load time, never recreated on the 500 ms price tick rebuilds.
const _kGainDecoration = BoxDecoration(
  color: AppColors.gainBackground,
  borderRadius: BorderRadius.all(Radius.circular(6)),
);
const _kLossDecoration = BoxDecoration(
  color: AppColors.lossBackground,
  borderRadius: BorderRadius.all(Radius.circular(6)),
);

/// A compact badge showing a percentage change with an optional arrow icon.
///
/// Open/Closed: adding neutral-state styling requires only a new const
/// decoration and an extra condition — no existing code path changes.
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

    // Select between two pre-allocated const decorations — zero heap allocation.
    final decoration = isGain ? _kGainDecoration : _kLossDecoration;
    final color      = isGain ? AppColors.gainColor : AppColors.lossColor;
    final icon       = isGain ? Icons.arrow_drop_up : Icons.arrow_drop_down;

    return DecoratedBox(
      decoration: decoration,
      child: Padding(
        padding: padding ??
            const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
