import 'package:flutter/cupertino.dart';

// Single source of truth for every color in the app.
// Add new colors here — never use Color literals in widget files.
class AppColors {
  AppColors._();

  // Backgrounds
  static const Color background = Color(0xffF5F1FF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF0F0F5);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFE8E8E8);

  // Brand
  static const Color primary = Color(0xFF6B4EFF);
  static const Color primaryLight = Color(0xFF9B7FFF);
  static const Color primaryDark = Color(0xFF4B2EDF);
  static const Color headerGradientStart = Color(0xFFB794F4);
  static const Color headerGradientEnd = Color(0xFF6B4EFF);

  // Text
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF666680);
  static const Color textMuted = Color(0xFF9999AA);
  static const Color textAccent = Color(0xFF444460);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Status — gain / loss
  static const Color gainColor = CupertinoColors.activeGreen;
  static const Color gainBackground = Color(0xFFE8F5E9);
  static const Color lossColor = CupertinoColors.destructiveRed;
  static const Color lossBackground = Color(0xFFFFEBEE);
  static const Color neutralColor = Color(0xFF9E9E9E);

  // Trade buttons
  static const Color buyColor = CupertinoColors.destructiveRed;
  static const Color buyBackground = Color(0xFFFFEBEE);
  static const Color sellColor = Color(0xFF1565C0);
  static const Color sellBackground = Color(0xFFE3F2FD);

  // Charts
  static const Color chartLineGain = CupertinoColors.activeGreen;
  static const Color chartLineLoss = CupertinoColors.destructiveRed;
  static const Color chartGrid = Color(0xFFEEEEEE);

  // Navigation
  static const Color navBackground = Color(0xFF6768E1);
  static const Color navSelected = Color(0xFF6B4EFF);
  static const Color navUnselected = Color(0xFFAAAAAA);
  static const Color divider = Color(0xFFEEEEEE);

  // Sub-tabs
  static const Color subTabActive = Color(0xFF6B4EFF);
  static const Color subTabInactive = Color(0xFF888888);

  // Balance chip
  static const Color balanceChipBg = Color(0xFFFFFFFF);
  static const Color balanceChipText = Color(0xFF1A1A2E);

  // Gradients
  static const LinearGradient headerGradient = LinearGradient(
    colors: [Color(0x99AF69C7), Color(0x99AF7CE3), Color(0x99436EDD)],
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
  );

  static const LinearGradient tabGradient = LinearGradient(
    colors: [Color(0xffAF69C7), Color(0xffAF7CE3), Color(0xff436EDD)],
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
  );

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6B4EFF), Color(0xFF9B7FFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient gainGradient = LinearGradient(
    colors: [CupertinoColors.activeGreen, CupertinoColors.systemGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8F8FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
