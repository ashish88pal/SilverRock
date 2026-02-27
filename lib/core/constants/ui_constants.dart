import 'package:flutter/material.dart';
import 'package:trading_demo_app/core/constants/app_constants.dart';

import '../theme/app_colors.dart';
// Pre-allocated BoxDecoration objects shared across multiple widgets.
// Declaring them here as top-level constants means Flutter creates them once
// at startup; hot-path build() methods can reference them without triggering
// any heap allocation.

const kNotifBadgeDecoration = BoxDecoration(
  color: Colors.red,
  shape: BoxShape.circle,
);

const kSearchBoxDecoration = BoxDecoration(
  color: AppColors.cardBackground,
  borderRadius: BorderRadius.all(Radius.circular(AppConstants.chipRadius)),
  border: Border.fromBorderSide(BorderSide(color: AppColors.cardBorder)),
);

const kCardDecoration = BoxDecoration(
  color: AppColors.cardBackground,
  borderRadius: BorderRadius.all(Radius.circular(AppConstants.cardRadius)),
  border: Border.fromBorderSide(BorderSide(color: AppColors.cardBorder)),
);

// Inner white container used in the balance chip on the market top bar.
final kBalanceInnerDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(AppConstants.cardRadius - 4),
);

// Gradient border wrapping the balance chip.
final kBalanceOuterDecoration = BoxDecoration(
  gradient: AppColors.tabGradient,
  border: Border(
    bottom: BorderSide(color: AppColors.headerGradientEnd, width: 5),
  ),
  borderRadius: BorderRadius.circular(AppConstants.cardRadius),
);
