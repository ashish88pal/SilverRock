// General app configuration — simulation timing, layout sizes, and animation
// durations. Add new values freely; never rename existing ones without updating
// all callers.
final class AppConstants {
  const AppConstants._();

  // Price simulation
  static const int priceUpdateIntervalMs = 500;
  static const double maxPriceChangePercent = 0.8;
  static const double minPriceChangePercent = 0.05;
  static const int chartDataPoints = 20;

  // Layout
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double cardRadius = 16.0;
  static const double chipRadius = 8.0;
  static const double iconSize = 20.0;
  static const double iconSizeLarge = 24.0;

  // Animations
  static const int priceAnimationMs = 150;
  static const int fadeAnimationMs = 200;

  // App identity
  static const String appName = 'SR';
  static const String currencySymbol = r'$';
}
