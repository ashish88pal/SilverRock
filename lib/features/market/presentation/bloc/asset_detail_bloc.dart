import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/market_asset.dart';
import '../../domain/usecases/market_usecases.dart';

// --- Events -----------------------------------------------------------------

sealed class AssetDetailEvent extends Equatable {
  const AssetDetailEvent();
  @override List<Object?> get props => [];
}

final class AssetDetailStarted extends AssetDetailEvent {
  final String assetId;
  const AssetDetailStarted(this.assetId);
  @override List<Object?> get props => [assetId];
}

final class AssetDetailPriceUpdated extends AssetDetailEvent {
  final MarketAsset asset;
  const AssetDetailPriceUpdated(this.asset);
  // Asset excluded from props — tick counter already signals the change.
  @override List<Object?> get props => [];
}

final class AssetDetailPeriodChanged extends AssetDetailEvent {
  final String period;
  const AssetDetailPeriodChanged(this.period);
  @override List<Object?> get props => [period];
}

// --- States -----------------------------------------------------------------

sealed class AssetDetailState extends Equatable {
  const AssetDetailState();
  @override List<Object?> get props => [];
}

final class AssetDetailInitial extends AssetDetailState {
  const AssetDetailInitial();
}

final class AssetDetailLoading extends AssetDetailState {
  const AssetDetailLoading();
}

final class AssetDetailLoaded extends AssetDetailState {
  const AssetDetailLoaded({
    required this.asset,
    this.selectedPeriod = '1D',
    int tick = 0,
  }) : _tick = tick;

  final MarketAsset asset;
  final String selectedPeriod;
  final int _tick;

  AssetDetailLoaded copyWith({
    MarketAsset? asset,
    String? selectedPeriod,
    bool incrementTick = false,
  }) => AssetDetailLoaded(
        asset:          asset          ?? this.asset,
        selectedPeriod: selectedPeriod ?? this.selectedPeriod,
        tick:           incrementTick ? _tick + 1 : _tick,
      );

  @override
  List<Object?> get props => [_tick, selectedPeriod];
}

final class AssetDetailError extends AssetDetailState {
  final String message;
  const AssetDetailError(this.message);
  @override List<Object?> get props => [message];
}

// --- BLoC -------------------------------------------------------------------

// Manages the live price stream and period selection for a single asset.
class AssetDetailBloc extends Bloc<AssetDetailEvent, AssetDetailState> {
  AssetDetailBloc({
    required GetAssetByIdUseCase getAssetById,
    required WatchSingleAssetUseCase watchAsset,
  })  : _getAssetById = getAssetById,
        _watchAsset   = watchAsset,
        super(const AssetDetailInitial()) {
    on<AssetDetailStarted>(_onStarted);
    on<AssetDetailPriceUpdated>(_onPriceUpdated);
    on<AssetDetailPeriodChanged>(_onPeriodChanged);
  }

  final GetAssetByIdUseCase _getAssetById;
  final WatchSingleAssetUseCase _watchAsset;
  StreamSubscription<MarketAsset>? _sub;

  Future<void> _onStarted(AssetDetailStarted event, Emitter<AssetDetailState> emit) async {
    emit(const AssetDetailLoading());
    try {
      final asset = await _getAssetById(event.assetId);
      if (asset == null) {
        emit(const AssetDetailError('Asset not found'));
        return;
      }
      emit(AssetDetailLoaded(asset: asset));
      await _sub?.cancel();
      _sub = _watchAsset(event.assetId).listen(
        (a) => add(AssetDetailPriceUpdated(a)),
      );
    } catch (e) {
      emit(AssetDetailError(e.toString()));
    }
  }

  void _onPriceUpdated(AssetDetailPriceUpdated event, Emitter<AssetDetailState> emit) {
    if (state is! AssetDetailLoaded) return;
    emit((state as AssetDetailLoaded).copyWith(
      asset:         event.asset,
      incrementTick: true,
    ));
  }

  void _onPeriodChanged(AssetDetailPeriodChanged event, Emitter<AssetDetailState> emit) {
    if (state is! AssetDetailLoaded) return;
    emit((state as AssetDetailLoaded).copyWith(selectedPeriod: event.period));
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
