import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

// Circular emoji avatar. Uses DecoratedBox + SizedBox (not Container) to
// skip the extra layout pass Container performs when child constraints are
// already fully determined.
class AssetLogo extends StatelessWidget {
  const AssetLogo({
    super.key,
    required this.emoji,
    this.size = 44,
    this.backgroundColor,
  });

  final String emoji;
  final double size;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color:  backgroundColor ?? AppColors.surfaceLight,
        shape:  BoxShape.circle,
        border: const Border.fromBorderSide(BorderSide(color: AppColors.cardBorder)),
      ),
      child: SizedBox(
        width: size, height: size,
        child: Center(
          child: Text(emoji, style: TextStyle(fontSize: size * 0.45)),
        ),
      ),
    );
  }
}
