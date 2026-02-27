import '../../../../core/usecases/use_case.dart';
import '../entities/market_asset.dart';
import '../repositories/market_repository.dart';

// Each use case does exactly one thing (Single Responsibility).
// They depend on the MarketRepository interface, never on implementations.

final class GetMarketAssetsUseCase implements FutureNoParamsUseCase<List<MarketAsset>> {
  const GetMarketAssetsUseCase(this._repository);
  final MarketRepository _repository;

  @override
  Future<List<MarketAsset>> call() => _repository.getMarketAssets();
}

final class WatchMarketAssetsUseCase implements StreamNoParamsUseCase<List<MarketAsset>> {
  const WatchMarketAssetsUseCase(this._repository);
  final MarketRepository _repository;

  @override
  Stream<List<MarketAsset>> call() => _repository.watchMarketAssets();
}

final class WatchSingleAssetUseCase implements StreamUseCase<MarketAsset, String> {
  const WatchSingleAssetUseCase(this._repository);
  final MarketRepository _repository;

  @override
  Stream<MarketAsset> call(String id) => _repository.watchAsset(id);
}

final class GetAssetByIdUseCase implements FutureUseCase<MarketAsset?, String> {
  const GetAssetByIdUseCase(this._repository);
  final MarketRepository _repository;

  @override
  Future<MarketAsset?> call(String id) => _repository.getAssetById(id);
}
