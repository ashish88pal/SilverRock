import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Circular emoji avatar.
///
/// Uses DecoratedBox + SizedBox instead of Container so Flutter can skip the
/// extra layout pass that Container always performs even when there's no child
/// size constraint conflict.
class AssetLogo extends StatelessWidget {
  final String emoji;
  final double size;
  final Color? backgroundColor;

  const AssetLogo({
    super.key,
    required this.emoji,
    this.size = 44,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surfaceLight,
        shape: BoxShape.circle,
        border: const Border.fromBorderSide(
          BorderSide(color: AppColors.cardBorder),
        ),
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: Center(
          child: Text(
            emoji,
            style: TextStyle(fontSize: size * 0.45),
          ),
        ),
      ),
    );
  }
}
