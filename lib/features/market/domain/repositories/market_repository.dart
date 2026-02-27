import '../entities/market_asset.dart';

// Any implementation — local, REST, WebSocket — can be swapped here without
// touching a single use case or BLoC (Liskov Substitution Principle).
abstract interface class MarketRepository {
  Future<List<MarketAsset>> getMarketAssets();
  Future<MarketAsset?> getAssetById(String id);
  Stream<List<MarketAsset>> watchMarketAssets();
  Stream<MarketAsset> watchAsset(String id);
}
