import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/market_asset.dart';
import '../../domain/usecases/market_usecases.dart';

// ── Events ────────────────────────────────────────────────────────────────

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
  // Exclude asset from props — heavy object, equality checked via tick.
  @override List<Object?> get props => [];
}

final class AssetDetailPeriodChanged extends AssetDetailEvent {
  final String period;
  const AssetDetailPeriodChanged(this.period);
  @override List<Object?> get props => [period];
}

// ── States ────────────────────────────────────────────────────────────────

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
  final MarketAsset asset;
  final String selectedPeriod;
  final int _tick;

  const AssetDetailLoaded({
    required this.asset,
    this.selectedPeriod = '1D',
    int tick = 0,
  }) : _tick = tick;

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

// ── BLoC ──────────────────────────────────────────────────────────────────

/// Manages a single asset's live price stream and period selection.
///
/// Presentation layer depends on this BLoC only — no direct use-case or
/// injection-container access in the widget tree (Clean Architecture).
class AssetDetailBloc extends Bloc<AssetDetailEvent, AssetDetailState> {
  final GetAssetByIdUseCase _getAssetById;
  final WatchSingleAssetUseCase _watchAsset;

  StreamSubscription<MarketAsset>? _subscription;

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

  Future<void> _onStarted(
    AssetDetailStarted event,
    Emitter<AssetDetailState> emit,
  ) async {
    emit(const AssetDetailLoading());
    try {
      final asset = await _getAssetById(event.assetId);
      if (asset == null) {
        emit(const AssetDetailError('Asset not found'));
        return;
      }
      emit(AssetDetailLoaded(asset: asset));
      await _subscription?.cancel();
      _subscription = _watchAsset(event.assetId).listen(
        (a) => add(AssetDetailPriceUpdated(a)),
      );
    } catch (e) {
      emit(AssetDetailError(e.toString()));
    }
  }

  void _onPriceUpdated(
    AssetDetailPriceUpdated event,
    Emitter<AssetDetailState> emit,
  ) {
    if (state is! AssetDetailLoaded) return;
    emit((state as AssetDetailLoaded).copyWith(
      asset:         event.asset,
      incrementTick: true,
    ));
  }

  void _onPeriodChanged(
    AssetDetailPeriodChanged event,
    Emitter<AssetDetailState> emit,
  ) {
    if (state is! AssetDetailLoaded) return;
    emit((state as AssetDetailLoaded).copyWith(selectedPeriod: event.period));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
