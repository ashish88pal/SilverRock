import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final Color? color;
  final double? borderRadius;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.color,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color ?? AppColors.cardBackground,
          borderRadius:
              BorderRadius.circular(borderRadius ?? AppConstants.cardRadius),
          border: Border.all(color: AppColors.cardBorder, width: 1),
        ),
        padding: padding ??
            const EdgeInsets.all(AppConstants.defaultPadding),
        child: child,
      ),
    );
  }
}
