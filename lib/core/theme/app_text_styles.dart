import 'package:flutter/material.dart';
import 'app_colors.dart';

// All text styles in one place. Reference these in widgets — never write
// inline TextStyle objects.
class AppTextStyles {
  AppTextStyles._();

  static const String _font = 'Inter';

  static const TextStyle displayLarge = TextStyle(fontFamily: _font, fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.textPrimary, letterSpacing: -0.5);
  static const TextStyle displayMedium = TextStyle(fontFamily: _font, fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary, letterSpacing: -0.3);

  static const TextStyle headlineLarge  = TextStyle(fontFamily: _font, fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary);
  static const TextStyle headlineMedium = TextStyle(fontFamily: _font, fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary);
  static const TextStyle headlineSmall  = TextStyle(fontFamily: _font, fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary);

  static const TextStyle titleMedium = TextStyle(fontFamily: _font, fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary);
  static const TextStyle titleSmall  = TextStyle(fontFamily: _font, fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary);

  static const TextStyle bodyLarge  = TextStyle(fontFamily: _font, fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.textPrimary);
  static const TextStyle bodyMedium = TextStyle(fontFamily: _font, fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.textSecondary);
  static const TextStyle bodySmall  = TextStyle(fontFamily: _font, fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textMuted);

  static const TextStyle labelLarge  = TextStyle(fontFamily: _font, fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary, letterSpacing: 0.1);
  static const TextStyle labelMedium = TextStyle(fontFamily: _font, fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSecondary, letterSpacing: 0.3);

  // Price-specific styles
  static const TextStyle priceDisplay = TextStyle(fontFamily: _font, fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textPrimary, letterSpacing: -0.5);
  static const TextStyle priceMedium  = TextStyle(fontFamily: _font, fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary);
  static const TextStyle priceSmall   = TextStyle(fontFamily: _font, fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary);

  static const TextStyle tabLabel = TextStyle(fontFamily: _font, fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.3);

  // Trade button prices
  static const TextStyle sellPrice = TextStyle(fontFamily: _font, fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.sellColor);
  static const TextStyle buyPrice  = TextStyle(fontFamily: _font, fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.buyColor);
}
