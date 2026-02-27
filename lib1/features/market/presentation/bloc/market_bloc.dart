import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/market_asset.dart';
import '../../domain/usecases/market_usecases.dart';
import 'market_event.dart';
import 'market_state.dart';

/// Manages the market list: live price updates, filtering, search, and sort.
///
/// Single-Responsibility: this class handles exactly the market-list state
/// machine. Chart data, detail pages, and portfolio state each have their
/// own BLoC.
///
/// Open/Closed: new sort types only require adding an enum value and a
/// [_applyFilters] case — no existing handlers change.
///
/// Liskov/Interface: [GetMarketAssetsUseCase] and [WatchMarketAssetsUseCase]
/// are injected as their abstract interface types, so any mock or alternative
/// implementation satisfies the contract without touching this class.
class MarketBloc extends Bloc<MarketEvent, MarketState> {
  final GetMarketAssetsUseCase _getMarketAssets;
  final WatchMarketAssetsUseCase _watchMarketAssets;

  StreamSubscription<List<MarketAsset>>? _priceSubscription;

  // Search debounce — prevents a full filter+sort pass on every keystroke.
  // 300 ms matches the standard UX guideline for search-field latency.
  Timer? _searchDebounce;
  static const _kSearchDebounce = Duration(milliseconds: 300);

  MarketBloc({
    required GetMarketAssetsUseCase getMarketAssets,
    required WatchMarketAssetsUseCase watchMarketAssets,
  }) : _getMarketAssets = getMarketAssets,
       _watchMarketAssets = watchMarketAssets,
       super(const MarketInitial()) {
    on<MarketStarted>(_onStarted);
    on<MarketAssetsUpdated>(_onAssetsUpdated);
    on<MarketFilterChanged>(_onFilterChanged);
    on<MarketSearchQueryChanged>(_onSearchChanged);
    on<MarketSearchApplied>(_onSearchApplied); // internal debounce result
    on<MarketSortChanged>(_onSortChanged);
  }

  // ── Handlers ──────────────────────────────────────────────────────────────

  Future<void> _onStarted(MarketStarted _, Emitter<MarketState> emit) async {
    emit(const MarketLoading());
    try {
      final assets = await _getMarketAssets();
      emit(MarketLoaded(allAssets: assets, filteredAssets: assets));
      await _priceSubscription?.cancel();
      _priceSubscription = _watchMarketAssets().listen(
        (assets) => add(MarketAssetsUpdated(assets)),
      );
    } catch (e) {
      emit(MarketError(e.toString()));
    }
  }

  void _onAssetsUpdated(MarketAssetsUpdated event, Emitter<MarketState> emit) {
    if (state is! MarketLoaded) return;
    final s = state as MarketLoaded;
    emit(
      s.copyWith(
        allAssets: event.assets,
        filteredAssets: _applyFilters(
          assets: event.assets,
          category: s.activeFilter,
          query: s.searchQuery,
          sort: s.sortType,
        ),
        incrementTick: true,
      ),
    );
  }

  void _onFilterChanged(MarketFilterChanged event, Emitter<MarketState> emit) {
    if (state is! MarketLoaded) return;
    final s = state as MarketLoaded;
    emit(
      s.copyWith(
        filteredAssets: _applyFilters(
          assets: s.allAssets,
          category: event.category,
          query: s.searchQuery,
          sort: s.sortType,
        ),
        activeFilter: event.category,
        clearFilter: event.category == null,
      ),
    );
  }

  void _onSearchChanged(
    MarketSearchQueryChanged event,
    Emitter<MarketState> emit,
  ) {
    // Cancel any pending search and restart the debounce window.
    _searchDebounce?.cancel();
    _searchDebounce = Timer(_kSearchDebounce, () {
      if (state is! MarketLoaded) return;
      final s = state as MarketLoaded;
      // add() — not emit() — because emit() is not accessible from a Timer
      // callback. add() routes through the event queue, keeping mutations serial.
      add(
        MarketSearchApplied(
          filteredAssets: _applyFilters(
            assets: s.allAssets,
            category: s.activeFilter,
            query: event.query,
            sort: s.sortType,
          ),
          query: event.query,
        ),
      );
    });
  }

  void _onSearchApplied(MarketSearchApplied event, Emitter<MarketState> emit) {
    if (state is! MarketLoaded) return;
    emit(
      (state as MarketLoaded).copyWith(
        filteredAssets: event.filteredAssets,
        searchQuery: event.query,
      ),
    );
  }

  void _onSortChanged(MarketSortChanged event, Emitter<MarketState> emit) {
    if (state is! MarketLoaded) return;
    final s = state as MarketLoaded;
    emit(
      s.copyWith(
        filteredAssets: _applyFilters(
          assets: s.allAssets,
          category: s.activeFilter,
          query: s.searchQuery,
          sort: event.sortType,
        ),
        sortType: event.sortType,
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  List<MarketAsset> _applyFilters({
    required List<MarketAsset> assets,
    AssetCategory? category,
    required String query,
    required MarketSortType sort,
  }) {
    // Single allocation: filter into a new list, then sort in-place.
    var result = category != null
        ? assets.where((a) => a.category == category).toList()
        : List<MarketAsset>.of(assets);

    if (query.isNotEmpty) {
      final q = query.toLowerCase();
      result = result
          .where(
            (a) =>
                a.symbol.toLowerCase().contains(q) ||
                a.name.toLowerCase().contains(q),
          )
          .toList();
    }

    switch (sort) {
      case MarketSortType.priceDesc:
        result.sort((a, b) => b.currentPrice.compareTo(a.currentPrice));
      case MarketSortType.priceAsc:
        result.sort((a, b) => a.currentPrice.compareTo(b.currentPrice));
      case MarketSortType.changeDesc:
        result.sort(
          (a, b) => b.priceChangePercent24h.compareTo(a.priceChangePercent24h),
        );
      case MarketSortType.changeAsc:
        result.sort(
          (a, b) => a.priceChangePercent24h.compareTo(b.priceChangePercent24h),
        );
      case MarketSortType.nameAsc:
        result.sort((a, b) => a.name.compareTo(b.name));
    }
    return result;
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    _priceSubscription?.cancel();
    return super.close();
  }
}
