import '../entities/market_asset.dart';

/// Repository contract for market data.
///
/// Liskov Substitution: any implementation (local, REST, WebSocket) that
/// satisfies this interface can be swapped without changing any use case or
/// BLoC.
abstract interface class MarketRepository {
  /// Returns the current snapshot of all instruments.
  Future<List<MarketAsset>> getMarketAssets();

  /// Returns a single instrument by [id], or null if not found.
  Future<MarketAsset?> getAssetById(String id);

  /// Emits updated instrument lists on every price tick.
  Stream<List<MarketAsset>> watchMarketAssets();

  /// Emits updates for a single instrument identified by [id].
  Stream<MarketAsset> watchAsset(String id);
}
