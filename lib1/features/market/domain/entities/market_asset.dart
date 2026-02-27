import 'package:equatable/equatable.dart';

/// A single tradeable instrument.
///
/// Value object (Equatable): two instances with the same id + prices are
/// considered equal — list identity is irrelevant.
///
/// Immutable: all fields are final; mutations produce a new instance via
/// [copyWith].
final class MarketAsset extends Equatable {
  const MarketAsset({
    required this.id,
    required this.symbol,
    required this.name,
    required this.logoEmoji,
    required this.currentPrice,
    required this.previousPrice,
    required this.openPrice,
    required this.high24h,
    required this.low24h,
    required this.volume24h,
    required this.marketCap,
    required this.priceChangePercent24h,
    required this.priceChange24h,
    required this.sparklineData,
    required this.category,
  });

  final String id;
  final String symbol;
  final String name;
  final String logoEmoji;
  final double currentPrice;
  final double previousPrice;
  final double openPrice;
  final double high24h;
  final double low24h;
  final double volume24h;
  final double marketCap;
  final double priceChangePercent24h;
  final double priceChange24h;
  final List<double> sparklineData;
  final AssetCategory category;

  bool get isGain   => priceChangePercent24h >= 0;
  bool get isPriceUp => currentPrice >= previousPrice;

  MarketAsset copyWith({
    double? currentPrice,
    double? previousPrice,
    double? high24h,
    double? low24h,
    double? volume24h,
    double? priceChangePercent24h,
    double? priceChange24h,
    List<double>? sparklineData,
  }) {
    return MarketAsset(
      id:                    id,
      symbol:                symbol,
      name:                  name,
      logoEmoji:             logoEmoji,
      currentPrice:          currentPrice          ?? this.currentPrice,
      previousPrice:         previousPrice         ?? this.previousPrice,
      openPrice:             openPrice,
      high24h:               high24h               ?? this.high24h,
      low24h:                low24h                ?? this.low24h,
      volume24h:             volume24h             ?? this.volume24h,
      marketCap:             marketCap,
      priceChangePercent24h: priceChangePercent24h ?? this.priceChangePercent24h,
      priceChange24h:        priceChange24h        ?? this.priceChange24h,
      sparklineData:         sparklineData         ?? this.sparklineData,
      category:              category,
    );
  }

  @override
  // sparklineData (List<double>) is intentionally excluded.
  // Equatable does a deep O(n) element-by-element comparison; on a 500 ms
  // tick with 12 assets × 20 data points that's 240 comparisons every 500 ms
  // for no benefit — the price and percent fields already capture every
  // meaningful state transition.
  List<Object?> get props => [
        id,
        symbol,
        currentPrice,
        previousPrice,
        priceChangePercent24h,
      ];
}

enum AssetCategory { crypto, stocks, forex, commodities }
