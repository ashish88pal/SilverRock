// ignore_for_file: avoid_classes_with_only_static_members

/// Application-wide compile-time constants.
///
/// Single-Responsibility: only constants, no logic.
/// Open/Closed: add new constants freely; never modify existing ones if the
/// change would break callers — add versioned alternatives instead.
final class AppConstants {
  // Private constructor — this class is a namespace, not an object.
  const AppConstants._();

  // ── Simulation ────────────────────────────────────────────────────────────
  /// Interval between price ticks (500 ms → 2 ticks/sec for a live-trading feel).
  static const int priceUpdateIntervalMs = 500;

  /// Maximum per-tick percentage move (±0.8 %).
  static const double maxPriceChangePercent = 0.8;

  /// Minimum per-tick percentage move (±0.05 %).
  static const double minPriceChangePercent = 0.05;

  /// Number of data points in the sparkline / detail chart.
  static const int chartDataPoints = 20;

  // ── UI ────────────────────────────────────────────────────────────────────
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double cardRadius = 16.0;
  static const double chipRadius = 8.0;
  static const double iconSize = 20.0;
  static const double iconSizeLarge = 24.0;

  // ── Animation ─────────────────────────────────────────────────────────────
  /// Price flash duration.  At 120 fps this is 18 frames — clearly visible
  /// without blocking the next tick.
  static const int priceAnimationMs = 150;

  /// Generic UI fade / slide duration.
  static const int fadeAnimationMs = 200;

  // ── Strings ───────────────────────────────────────────────────────────────
  static const String appName = 'TradeX';
  static const String currencySymbol = r'$';
}
