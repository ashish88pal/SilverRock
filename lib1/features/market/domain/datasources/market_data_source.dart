import '../entities/market_asset.dart';

/// Contract for a market data provider.
///
/// Lives in the domain layer so that use cases and repositories can depend on
/// it without importing anything from the data layer — preserving the
/// Dependency Rule of Clean Architecture (outer layers depend on inner layers,
/// never the reverse).
abstract interface class MarketDataSource {
  Future<List<MarketAsset>> getMarketAssets();
  Future<MarketAsset?> getAssetById(String id);
  Stream<List<MarketAsset>> watchMarketAssets();
  Stream<MarketAsset> watchAsset(String id);
}
