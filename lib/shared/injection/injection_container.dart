import 'package:get_it/get_it.dart';

import '../../features/market/data/datasources/market_local_datasource.dart';
import '../../features/market/data/repositories/market_repository_impl.dart';
import '../../features/market/domain/datasources/market_data_source.dart';
import '../../features/market/domain/repositories/market_repository.dart';
import '../../features/market/domain/usecases/market_usecases.dart';
import '../../features/market/presentation/bloc/asset_detail_bloc.dart';
import '../../features/market/presentation/bloc/market_bloc.dart';

// Application-wide service locator.
//
// Dependency direction (arrows mean "depends on"):
//   BLoCs → use cases → repository interfaces → data source interfaces
//   Only this file imports concrete implementations.
final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  // Data sources — singletons because they own timers / stream controllers.
  sl.registerLazySingleton<MarketDataSource>(() => MarketLocalDataSource());

  // Repositories
  sl.registerLazySingleton<MarketRepository>(
    () => MarketRepositoryImpl(sl<MarketDataSource>()),
  );

  // Market use cases
  sl.registerLazySingleton(
    () => GetMarketAssetsUseCase(sl<MarketRepository>()),
  );
  sl.registerLazySingleton(
    () => WatchMarketAssetsUseCase(sl<MarketRepository>()),
  );
  sl.registerLazySingleton(
    () => WatchSingleAssetUseCase(sl<MarketRepository>()),
  );
  sl.registerLazySingleton(() => GetAssetByIdUseCase(sl<MarketRepository>()));

  // BLoCs — factory so each page gets a fresh instance that closes with the widget.
  sl.registerFactory(
    () => MarketBloc(
      getMarketAssets: sl<GetMarketAssetsUseCase>(),
      watchMarketAssets: sl<WatchMarketAssetsUseCase>(),
    ),
  );
  sl.registerFactory(
    () => AssetDetailBloc(
      getAssetById: sl<GetAssetByIdUseCase>(),
      watchAsset: sl<WatchSingleAssetUseCase>(),
    ),
  );
}
