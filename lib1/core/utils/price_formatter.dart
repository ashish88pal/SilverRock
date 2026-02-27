import 'package:intl/intl.dart';

class PriceFormatter {
  PriceFormatter._();

  static final NumberFormat _priceFormat = NumberFormat('#,##0.00', 'en_US');
  static final NumberFormat _compactFormat = NumberFormat.compact();
  static final NumberFormat _percentFormat = NumberFormat('+0.00;-0.00', 'en_US');
  static final NumberFormat _volumeFormat = NumberFormat('#,##0', 'en_US');

  static String formatPrice(double price) {
    return '\$${_priceFormat.format(price)}';
  }

  static String formatPriceRaw(double price) {
    return _priceFormat.format(price);
  }

  static String formatPercent(double percent) {
    return '${_percentFormat.format(percent)}%';
  }

  static String formatCompact(double value) {
    return '\$${_compactFormat.format(value)}';
  }

  static String formatVolume(double volume) {
    return _volumeFormat.format(volume);
  }

  static String formatMarketCap(double marketCap) {
    if (marketCap >= 1e12) {
      return '\$${(marketCap / 1e12).toStringAsFixed(2)}T';
    } else if (marketCap >= 1e9) {
      return '\$${(marketCap / 1e9).toStringAsFixed(2)}B';
    } else if (marketCap >= 1e6) {
      return '\$${(marketCap / 1e6).toStringAsFixed(2)}M';
    }
    return '\$${_priceFormat.format(marketCap)}';
  }

  static String formatChange(double change) {
    final sign = change >= 0 ? '+' : '';
    return '$sign${_priceFormat.format(change)}';
  }
}
