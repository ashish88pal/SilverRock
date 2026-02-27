import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/market_asset.dart';
import '../../domain/usecases/market_usecases.dart';
import 'market_event.dart';
import 'market_state.dart';

// Manages market list state: live price updates, filter, search, and sort.
// Each concern is handled by a separate private method — easy to find and test.
class MarketBloc extends Bloc<MarketEvent, MarketState> {
  MarketBloc({
    required GetMarketAssetsUseCase getMarketAssets,
    required WatchMarketAssetsUseCase watchMarketAssets,
  })  : _getMarketAssets   = getMarketAssets,
        _watchMarketAssets = watchMarketAssets,
        super(const MarketInitial()) {
    on<MarketStarted>(_onStarted);
    on<MarketAssetsUpdated>(_onAssetsUpdated);
    on<MarketFilterChanged>(_onFilterChanged);
    on<MarketSearchQueryChanged>(_onSearchChanged);
    on<MarketSearchApplied>(_onSearchApplied);
    on<MarketSortChanged>(_onSortChanged);
  }

  final GetMarketAssetsUseCase _getMarketAssets;
  final WatchMarketAssetsUseCase _watchMarketAssets;

  StreamSubscription<List<MarketAsset>>? _priceSub;

  // Search debounce: wait 300 ms after the last keystroke before filtering.
  Timer? _searchDebounce;
  static const _kSearchDelay = Duration(milliseconds: 300);

  // --- Event handlers -----------------------------------------------------

  Future<void> _onStarted(MarketStarted _, Emitter<MarketState> emit) async {
    emit(const MarketLoading());
    try {
      final assets = await _getMarketAssets();
      emit(MarketLoaded(allAssets: assets, filteredAssets: assets));
      await _priceSub?.cancel();
      _priceSub = _watchMarketAssets().listen(
        (updated) => add(MarketAssetsUpdated(updated)),
      );
    } catch (e) {
      emit(MarketError(e.toString()));
    }
  }

  void _onAssetsUpdated(MarketAssetsUpdated event, Emitter<MarketState> emit) {
    if (state is! MarketLoaded) return;
    final s = state as MarketLoaded;
    emit(s.copyWith(
      allAssets:      event.assets,
      filteredAssets: _applyFilters(
        assets:   event.assets,
        category: s.activeFilter,
        query:    s.searchQuery,
        sort:     s.sortType,
      ),
      incrementTick: true,
    ));
  }

  void _onFilterChanged(MarketFilterChanged event, Emitter<MarketState> emit) {
    if (state is! MarketLoaded) return;
    final s = state as MarketLoaded;
    emit(s.copyWith(
      filteredAssets: _applyFilters(
        assets:   s.allAssets,
        category: event.category,
        query:    s.searchQuery,
        sort:     s.sortType,
      ),
      activeFilter: event.category,
      clearFilter:  event.category == null,
    ));
  }

  void _onSearchChanged(MarketSearchQueryChanged event, Emitter<MarketState> emit) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(_kSearchDelay, () {
      if (state is! MarketLoaded) return;
      final s = state as MarketLoaded;
      // Use add() not emit() — Timer callbacks run outside the event queue,
      // so routing through add() keeps state mutations serial.
      add(MarketSearchApplied(
        filteredAssets: _applyFilters(
          assets:   s.allAssets,
          category: s.activeFilter,
          query:    event.query,
          sort:     s.sortType,
        ),
        query: event.query,
      ));
    });
  }

  void _onSearchApplied(MarketSearchApplied event, Emitter<MarketState> emit) {
    if (state is! MarketLoaded) return;
    emit((state as MarketLoaded).copyWith(
      filteredAssets: event.filteredAssets,
      searchQuery:    event.query,
    ));
  }

  void _onSortChanged(MarketSortChanged event, Emitter<MarketState> emit) {
    if (state is! MarketLoaded) return;
    final s = state as MarketLoaded;
    emit(s.copyWith(
      filteredAssets: _applyFilters(
        assets:   s.allAssets,
        category: s.activeFilter,
        query:    s.searchQuery,
        sort:     event.sortType,
      ),
      sortType: event.sortType,
    ));
  }

  // --- Filter / sort helper -----------------------------------------------

  List<MarketAsset> _applyFilters({
    required List<MarketAsset> assets,
    AssetCategory? category,
    required String query,
    required MarketSortType sort,
  }) {
    var result = category != null
        ? assets.where((a) => a.category == category).toList()
        : List<MarketAsset>.of(assets);

    if (query.isNotEmpty) {
      final q = query.toLowerCase();
      result = result
          .where((a) =>
              a.symbol.toLowerCase().contains(q) ||
              a.name.toLowerCase().contains(q))
          .toList();
    }

    switch (sort) {
      case MarketSortType.priceDesc:
        result.sort((a, b) => b.currentPrice.compareTo(a.currentPrice));
      case MarketSortType.priceAsc:
        result.sort((a, b) => a.currentPrice.compareTo(b.currentPrice));
      case MarketSortType.changeDesc:
        result.sort((a, b) => b.priceChangePercent24h.compareTo(a.priceChangePercent24h));
      case MarketSortType.changeAsc:
        result.sort((a, b) => a.priceChangePercent24h.compareTo(b.priceChangePercent24h));
      case MarketSortType.nameAsc:
        result.sort((a, b) => a.name.compareTo(b.name));
    }
    return result;
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    _priceSub?.cancel();
    return super.close();
  }
}
