import 'dart:async';
import 'dart:math';
import '../../domain/datasources/market_data_source.dart';
import '../../domain/entities/market_asset.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/asset_constants.dart';

// Simulates a live market feed. Reads the seed data from asset_constants.dart
// and ticks every 500 ms to update prices with a random walk.
final class MarketLocalDataSource implements MarketDataSource {
  MarketLocalDataSource() {
    _assets = _buildSeedAssets();
    _startTimer();
  }

  final _random = Random();
  late List<MarketAsset> _assets;

  final _controller = StreamController<List<MarketAsset>>.broadcast();
  Timer? _timer;

  // --- Seed data ----------------------------------------------------------

  // Builds the initial asset list from the kAssetSeeds constant.
  List<MarketAsset> _buildSeedAssets() {
    return kAssetSeeds.map((s) => _buildFromSeed(s)).toList(growable: false);
  }

  MarketAsset _buildFromSeed(AssetSeed s) {
    final change = s.price * s.pct / 100;
    final open   = s.price - change;
    return MarketAsset(
      id:                    s.id,
      symbol:                s.symbol,
      name:                  s.name,
      logoEmoji:             s.emoji,
      currentPrice:          s.price,
      previousPrice:         s.price,
      openPrice:             open,
      high24h:               s.price * (1 + _random.nextDouble() * 0.03),
      low24h:                s.price * (1 - _random.nextDouble() * 0.03),
      volume24h:             s.vol,
      marketCap:             s.cap,
      priceChangePercent24h: s.pct,
      priceChange24h:        change,
      sparklineData:         _buildSparkline(s.price, s.pct),
      category:              _parseCategory(s.category),
    );
  }

  List<double> _buildSparkline(double price, double pct) {
    const n = AppConstants.chartDataPoints;
    final pts = <double>[];
    for (var i = 0; i < n; i++) {
      final progress = i / (n - 1);
      final trend    = pct / 100 * progress * price;
      final noise    = (_random.nextDouble() - 0.5) * price * 0.01;
      pts.add(
        (price - price * pct / 100 + trend + noise)
            .clamp(price * 0.95, price * 1.05),
      );
    }
    pts.last = price;
    return pts;
  }

  AssetCategory _parseCategory(String raw) {
    return switch (raw) {
      'crypto'      => AssetCategory.crypto,
      'stocks'      => AssetCategory.stocks,
      'forex'       => AssetCategory.forex,
      'commodities' => AssetCategory.commodities,
      _             => AssetCategory.crypto,
    };
  }

  // --- Price simulation ---------------------------------------------------

  void _startTimer() {
    _timer = Timer.periodic(
      const Duration(milliseconds: AppConstants.priceUpdateIntervalMs),
      (_) => _tick(),
    );
  }

  void _tick() {
    _assets = List<MarketAsset>.generate(
      _assets.length,
      (i) => _stepPrice(_assets[i]),
      growable: false,
    );
    if (!_controller.isClosed) {
      _controller.add(List.unmodifiable(_assets));
    }
  }

  // Applies a small random move to a single asset each tick.
  MarketAsset _stepPrice(MarketAsset a) {
    final direction = _random.nextDouble() < 0.52 ? 1.0 : -1.0;
    final magnitude = (AppConstants.minPriceChangePercent +
        _random.nextDouble() *
        (AppConstants.maxPriceChangePercent - AppConstants.minPriceChangePercent)) / 100;

    final newPrice = (a.currentPrice + a.currentPrice * magnitude * direction)
        .clamp(a.currentPrice * 0.5, a.currentPrice * 2.0);

    final newPct    = (newPrice - a.openPrice) / a.openPrice * 100;
    final newChange = newPrice - a.openPrice;

    // Slide the sparkline window: drop the oldest point, append the new price.
    final old = a.sparklineData;
    final neo = List<double>.filled(old.length, 0.0, growable: false);
    for (var i = 1; i < old.length; i++) {
      neo[i - 1] = old[i];
    }
    neo[old.length - 1] = newPrice;

    return a.copyWith(
      previousPrice:         a.currentPrice,
      currentPrice:          newPrice,
      priceChangePercent24h: newPct,
      priceChange24h:        newChange,
      sparklineData:         neo,
      high24h:               newPrice > a.high24h ? newPrice : a.high24h,
      low24h:                newPrice < a.low24h  ? newPrice : a.low24h,
    );
  }

  // --- MarketDataSource ---------------------------------------------------

  @override
  Future<List<MarketAsset>> getMarketAssets() async => List.unmodifiable(_assets);

  @override
  Future<MarketAsset?> getAssetById(String id) async {
    try {
      return _assets.firstWhere((a) => a.id == id);
    } on StateError {
      return null;
    }
  }

  @override
  Stream<List<MarketAsset>> watchMarketAssets() => _controller.stream;

  @override
  Stream<MarketAsset> watchAsset(String id) =>
      _controller.stream.map((list) => list.firstWhere((a) => a.id == id));

  void dispose() {
    _timer?.cancel();
    _controller.close();
  }
}
