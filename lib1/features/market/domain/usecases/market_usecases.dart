import '../../../../core/usecases/use_case.dart';
import '../entities/market_asset.dart';
import '../repositories/market_repository.dart';

/// Returns the current snapshot of all market assets.
final class GetMarketAssetsUseCase implements FutureNoParamsUseCase<List<MarketAsset>> {
  const GetMarketAssetsUseCase(this._repository);
  final MarketRepository _repository;

  @override
  Future<List<MarketAsset>> call() => _repository.getMarketAssets();
}

/// Streams live price updates for all market assets.
final class WatchMarketAssetsUseCase implements StreamNoParamsUseCase<List<MarketAsset>> {
  const WatchMarketAssetsUseCase(this._repository);
  final MarketRepository _repository;

  @override
  Stream<List<MarketAsset>> call() => _repository.watchMarketAssets();
}

/// Streams live price updates for a single asset identified by [id].
final class WatchSingleAssetUseCase implements StreamUseCase<MarketAsset, String> {
  const WatchSingleAssetUseCase(this._repository);
  final MarketRepository _repository;

  @override
  Stream<MarketAsset> call(String id) => _repository.watchAsset(id);
}

/// Returns a single asset by [id], or null if not found.
final class GetAssetByIdUseCase implements FutureUseCase<MarketAsset?, String> {
  const GetAssetByIdUseCase(this._repository);
  final MarketRepository _repository;

  @override
  Future<MarketAsset?> call(String id) => _repository.getAssetById(id);
}
