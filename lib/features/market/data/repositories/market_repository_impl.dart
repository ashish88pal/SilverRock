import '../../domain/datasources/market_data_source.dart';
import '../../domain/entities/market_asset.dart';
import '../../domain/repositories/market_repository.dart';

// Thin adapter between the domain repository contract and the data source.
// To add caching, compose a CachedMarketDataSource here instead of modifying
// this class (Open/Closed Principle).
final class MarketRepositoryImpl implements MarketRepository {
  const MarketRepositoryImpl(this._dataSource);

  final MarketDataSource _dataSource;

  @override
  Future<List<MarketAsset>> getMarketAssets() => _dataSource.getMarketAssets();

  @override
  Future<MarketAsset?> getAssetById(String id) => _dataSource.getAssetById(id);

  @override
  Stream<List<MarketAsset>> watchMarketAssets() => _dataSource.watchMarketAssets();

  @override
  Stream<MarketAsset> watchAsset(String id) => _dataSource.watchAsset(id);
}
