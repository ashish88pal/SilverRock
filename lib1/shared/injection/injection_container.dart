import 'package:get_it/get_it.dart';

// Data Sources (concrete impls — domain contracts are the abstractions)
import '../../features/market/data/datasources/market_local_datasource.dart';

// Domain contracts (DIP: everything depends on these, not on impls)
import '../../features/market/domain/datasources/market_data_source.dart';
import '../../features/market/domain/repositories/market_repository.dart';

// Repository implementations
import '../../features/market/data/repositories/market_repository_impl.dart';

// Use cases
import '../../features/market/domain/usecases/market_usecases.dart';

// BLoCs
import '../../features/market/presentation/bloc/market_bloc.dart';
import '../../features/market/presentation/bloc/asset_detail_bloc.dart';

/// Application-wide [GetIt] service locator.
///
/// Dependency graph (Dependency Inversion Principle):
///   BLoCs ──▶ Use-case interfaces
///   Use cases ──▶ Repository interfaces
///   Repository impls ──▶ DataSource interfaces
///   DataSource impls ◀── registered here only, never imported by domain/presentation
final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  // ── Data Sources ──────────────────────────────────────────────────────────
  // MarketLocalDataSource: singleton — one simulation Timer drives the whole app.
  sl.registerLazySingleton<MarketDataSource>(() => MarketLocalDataSource());

  // ── Repositories ──────────────────────────────────────────────────────────
  sl.registerLazySingleton<MarketRepository>(
    () => MarketRepositoryImpl(sl<MarketDataSource>()),
  );

  // ── Use Cases ─────────────────────────────────────────────────────────────
  sl.registerLazySingleton<GetMarketAssetsUseCase>(
    () => GetMarketAssetsUseCase(sl<MarketRepository>()),
  );
  sl.registerLazySingleton<WatchMarketAssetsUseCase>(
    () => WatchMarketAssetsUseCase(sl<MarketRepository>()),
  );
  sl.registerLazySingleton<WatchSingleAssetUseCase>(
    () => WatchSingleAssetUseCase(sl<MarketRepository>()),
  );
  sl.registerLazySingleton<GetAssetByIdUseCase>(
    () => GetAssetByIdUseCase(sl<MarketRepository>()),
  );

  // ── BLoCs (factory — new instance per page, closed with widget) ───────────
  sl.registerFactory<MarketBloc>(
    () => MarketBloc(
      getMarketAssets: sl<GetMarketAssetsUseCase>(),
      watchMarketAssets: sl<WatchMarketAssetsUseCase>(),
    ),
  );
  sl.registerFactory<AssetDetailBloc>(
    () => AssetDetailBloc(
      getAssetById: sl<GetAssetByIdUseCase>(),
      watchAsset: sl<WatchSingleAssetUseCase>(),
    ),
  );
}
