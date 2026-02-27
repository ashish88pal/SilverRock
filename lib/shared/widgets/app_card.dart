import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';

// Generic tappable card used across multiple screens.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.color,
    this.borderRadius,
  });

  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final Color? color;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.all(AppConstants.defaultPadding),
        decoration: BoxDecoration(
          color:        color ?? AppColors.cardBackground,
          borderRadius: BorderRadius.circular(borderRadius ?? AppConstants.cardRadius),
          border:       Border.all(color: AppColors.cardBorder),
        ),
        child: child,
      ),
    );
  }
}
