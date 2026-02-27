import '../../domain/datasources/market_data_source.dart';
import '../../domain/entities/market_asset.dart';
import '../../domain/repositories/market_repository.dart';

/// Concrete [MarketRepository] backed by a [MarketDataSource].
///
/// Open/Closed: to add caching, compose a CachedMarketDataSource instead of
/// modifying this class.
final class MarketRepositoryImpl implements MarketRepository {
  const MarketRepositoryImpl(this._dataSource);

  final MarketDataSource _dataSource;

  @override
  Future<List<MarketAsset>> getMarketAssets() => _dataSource.getMarketAssets();

  @override
  Future<MarketAsset?> getAssetById(String id) => _dataSource.getAssetById(id);

  @override
  Stream<List<MarketAsset>> watchMarketAssets() =>
      _dataSource.watchMarketAssets();

  @override
  Stream<MarketAsset> watchAsset(String id) => _dataSource.watchAsset(id);
}
