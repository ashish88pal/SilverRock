import 'package:intl/intl.dart';

// Utility class that formats raw numbers into display strings.
// All formatters are module-level singletons — NumberFormat is expensive to
// construct so we create each one once.
class PriceFormatter {
  PriceFormatter._();

  static final _price   = NumberFormat('#,##0.00',     'en_US');
  static final _compact = NumberFormat.compact();
  static final _percent = NumberFormat('+0.00;-0.00', 'en_US');
  static final _volume  = NumberFormat('#,##0',        'en_US');

  static String formatPrice(double price)     => '\$${_price.format(price)}';
  static String formatPriceRaw(double price)  => _price.format(price);
  static String formatPercent(double percent) => '${_percent.format(percent)}%';
  static String formatCompact(double value)   => '\$${_compact.format(value)}';
  static String formatVolume(double volume)   => _volume.format(volume);

  static String formatMarketCap(double cap) {
    if (cap >= 1e12) return '\$${(cap / 1e12).toStringAsFixed(2)}T';
    if (cap >= 1e9)  return '\$${(cap / 1e9).toStringAsFixed(2)}B';
    if (cap >= 1e6)  return '\$${(cap / 1e6).toStringAsFixed(2)}M';
    return '\$${_price.format(cap)}';
  }

  static String formatChange(double change) {
    final sign = change >= 0 ? '+' : '';
    return '$sign${_price.format(change)}';
  }
}
