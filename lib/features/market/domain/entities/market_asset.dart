import 'package:equatable/equatable.dart';

// A single tradeable instrument. Immutable value object — all mutations
// return a new instance via copyWith.
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

  bool get isGain    => priceChangePercent24h >= 0;
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

  // sparklineData is intentionally excluded from props. Deep-comparing
  // 20 doubles per asset on every 500 ms tick (12 assets) adds up quickly
  // for zero practical benefit — the price fields already capture all
  // meaningful state changes.
  @override
  List<Object?> get props => [id, symbol, currentPrice, previousPrice, priceChangePercent24h];
}

enum AssetCategory { crypto, stocks, forex, commodities }
