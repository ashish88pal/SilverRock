import 'dart:async';
import 'dart:math';
import '../../domain/datasources/market_data_source.dart';
import '../../domain/entities/market_asset.dart';
import '../../../../core/constants/app_constants.dart';

/// Simulates a live market feed with 500 ms price ticks.
///
/// Single Responsibility: owns only price simulation + stream emission.
/// The abstract [MarketDataSource] interface lives in domain — this class
/// depends inward on the domain contract, never the reverse.
final class MarketLocalDataSource implements MarketDataSource {
  final Random _random = Random();
  List<MarketAsset> _assets = const [];
  final StreamController<List<MarketAsset>> _streamController =
      StreamController<List<MarketAsset>>.broadcast();
  Timer? _simulationTimer;

  MarketLocalDataSource() {
    _assets = _initAssets();
    _startSimulation();
  }

  // ── Seed Data ─────────────────────────────────────────────────────────────

  List<MarketAsset> _initAssets() => [
    _build(
      id: 'btc',
      sym: 'BTC',
      name: 'Bitcoin',
      emoji: '₿',
      price: 67_234.50,
      vol: 28_450_000_000,
      cap: 1_320_000_000_000,
      pct: 2.34,
      cat: AssetCategory.crypto,
    ),
    _build(
      id: 'eth',
      sym: 'ETH',
      name: 'Ethereum',
      emoji: 'Ξ',
      price: 3_512.80,
      vol: 14_200_000_000,
      cap: 422_000_000_000,
      pct: -1.12,
      cat: AssetCategory.crypto,
    ),
    _build(
      id: 'sol',
      sym: 'SOL',
      name: 'Solana',
      emoji: '◎',
      price: 178.45,
      vol: 3_100_000_000,
      cap: 79_000_000_000,
      pct: 5.67,
      cat: AssetCategory.crypto,
    ),
    _build(
      id: 'bnb',
      sym: 'BNB',
      name: 'BNB',
      emoji: '⬡',
      price: 594.30,
      vol: 1_800_000_000,
      cap: 87_000_000_000,
      pct: 0.89,
      cat: AssetCategory.crypto,
    ),
    _build(
      id: 'xrp',
      sym: 'XRP',
      name: 'XRP',
      emoji: '✕',
      price: 0.62,
      vol: 2_300_000_000,
      cap: 33_000_000_000,
      pct: -3.21,
      cat: AssetCategory.crypto,
    ),
    _build(
      id: 'ada',
      sym: 'ADA',
      name: 'Cardano',
      emoji: '₳',
      price: 0.58,
      vol: 890_000_000,
      cap: 20_000_000_000,
      pct: 1.45,
      cat: AssetCategory.crypto,
    ),
    _build(
      id: 'aapl',
      sym: 'AAPL',
      name: 'Apple Inc.',
      emoji: '🍎',
      price: 189.75,
      vol: 72_000_000,
      cap: 2_940_000_000_000,
      pct: 0.54,
      cat: AssetCategory.stocks,
    ),
    _build(
      id: 'tsla',
      sym: 'TSLA',
      name: 'Tesla Inc.',
      emoji: '⚡',
      price: 248.42,
      vol: 120_000_000,
      cap: 790_000_000_000,
      pct: -2.87,
      cat: AssetCategory.stocks,
    ),
    _build(
      id: 'googl',
      sym: 'GOOGL',
      name: 'Alphabet',
      emoji: '🔍',
      price: 175.23,
      vol: 25_000_000,
      cap: 2_200_000_000_000,
      pct: 1.23,
      cat: AssetCategory.stocks,
    ),
    _build(
      id: 'msft',
      sym: 'MSFT',
      name: 'Microsoft',
      emoji: '🪟',
      price: 415.80,
      vol: 18_000_000,
      cap: 3_090_000_000_000,
      pct: 0.76,
      cat: AssetCategory.stocks,
    ),
    _build(
      id: 'xauusd',
      sym: 'XAU/USD',
      name: 'Gold',
      emoji: '🥇',
      price: 2_034.50,
      vol: 15_000_000_000,
      cap: 13_000_000_000_000,
      pct: 0.32,
      cat: AssetCategory.commodities,
    ),
    _build(
      id: 'eurusd',
      sym: 'EUR/USD',
      name: 'Euro / Dollar',
      emoji: '€',
      price: 1.0845,
      vol: 20_000_000_000,
      cap: 0,
      pct: -0.12,
      cat: AssetCategory.forex,
    ),
  ];

  MarketAsset _build({
    required String id,
    required String sym,
    required String name,
    required String emoji,
    required double price,
    required double vol,
    required double cap,
    required double pct,
    required AssetCategory cat,
  }) {
    final change = price * pct / 100;
    final open = price - change;
    return MarketAsset(
      id: id,
      symbol: sym,
      name: name,
      logoEmoji: emoji,
      currentPrice: price,
      previousPrice: price,
      openPrice: open,
      high24h: price * (1 + _random.nextDouble() * 0.03),
      low24h: price * (1 - _random.nextDouble() * 0.03),
      volume24h: vol,
      marketCap: cap,
      priceChangePercent24h: pct,
      priceChange24h: change,
      sparklineData: _sparkline(price, pct),
      category: cat,
    );
  }

  List<double> _sparkline(double price, double pct) {
    const n = AppConstants.chartDataPoints;
    final pts = <double>[];
    for (var i = 0; i < n; i++) {
      final prog = i / (n - 1);
      final trend = pct / 100 * prog * price;
      final noise = (_random.nextDouble() - 0.5) * price * 0.01;
      pts.add(
        (price - price * pct / 100 + trend + noise).clamp(
          price * 0.95,
          price * 1.05,
        ),
      );
    }
    pts.last = price;
    return pts;
  }

  // ── Simulation ────────────────────────────────────────────────────────────

  void _startSimulation() {
    _simulationTimer = Timer.periodic(
      const Duration(milliseconds: AppConstants.priceUpdateIntervalMs),
      (_) => _tick(),
    );
  }

  void _tick() {
    _assets = List<MarketAsset>.generate(
      _assets.length,
      (i) => _step(_assets[i]),
      growable: false,
    );
    if (!_streamController.isClosed) {
      _streamController.add(List.unmodifiable(_assets));
    }
  }

  MarketAsset _step(MarketAsset a) {
    final bias = _random.nextDouble() < 0.52 ? 1.0 : -1.0;
    final mag =
        (AppConstants.minPriceChangePercent +
            _random.nextDouble() *
                (AppConstants.maxPriceChangePercent -
                    AppConstants.minPriceChangePercent)) /
        100;

    final newPrice = (a.currentPrice + a.currentPrice * mag * bias).clamp(
      a.currentPrice * 0.5,
      a.currentPrice * 2.0,
    );

    final newPct = (newPrice - a.openPrice) / a.openPrice * 100;
    final newChange = newPrice - a.openPrice;

    // Slide the sparkline window forward.
    final old = a.sparklineData;
    final neo = List<double>.filled(old.length, 0.0, growable: false);
    for (var i = 1; i < old.length; i++) {
      neo[i - 1] = old[i];
    }
    neo[old.length - 1] = newPrice;

    return a.copyWith(
      previousPrice: a.currentPrice,
      currentPrice: newPrice,
      priceChangePercent24h: newPct,
      priceChange24h: newChange,
      sparklineData: neo,
      high24h: newPrice > a.high24h ? newPrice : a.high24h,
      low24h: newPrice < a.low24h ? newPrice : a.low24h,
    );
  }

  // ── MarketDataSource ──────────────────────────────────────────────────────

  @override
  Future<List<MarketAsset>> getMarketAssets() async =>
      List.unmodifiable(_assets);

  @override
  Future<MarketAsset?> getAssetById(String id) async {
    try {
      return _assets.firstWhere((a) => a.id == id);
    } on StateError {
      return null;
    }
  }

  @override
  Stream<List<MarketAsset>> watchMarketAssets() => _streamController.stream;

  @override
  Stream<MarketAsset> watchAsset(String id) => _streamController.stream.map(
    (list) => list.firstWhere((a) => a.id == id),
  );

  void dispose() {
    _simulationTimer?.cancel();
    _streamController.close();
  }
}
