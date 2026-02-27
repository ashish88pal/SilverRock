import '../entities/market_asset.dart';

// Lives in domain so use cases and repositories can depend on it without
// importing anything from the data layer (Clean Architecture dependency rule).
abstract interface class MarketDataSource {
  Future<List<MarketAsset>> getMarketAssets();
  Future<MarketAsset?> getAssetById(String id);
  Stream<List<MarketAsset>> watchMarketAssets();
  Stream<MarketAsset> watchAsset(String id);
}
