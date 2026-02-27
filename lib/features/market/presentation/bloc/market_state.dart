import 'package:equatable/equatable.dart';
import '../../domain/entities/market_asset.dart';
import 'market_event.dart';

sealed class MarketState extends Equatable {
  const MarketState();

  @override
  List<Object?> get props => [];
}

final class MarketInitial extends MarketState {
  const MarketInitial();
}

final class MarketLoading extends MarketState {
  const MarketLoading();
}

final class MarketLoaded extends MarketState {
  const MarketLoaded({
    required this.allAssets,
    required this.filteredAssets,
    this.activeFilter,
    this.searchQuery = '',
    this.sortType = MarketSortType.priceDesc,
    int tick = 0,
  }) : _tick = tick;

  final List<MarketAsset> allAssets;
  final List<MarketAsset> filteredAssets;
  final AssetCategory? activeFilter;
  final String searchQuery;
  final MarketSortType sortType;

  // Monotonic counter incremented on each price tick. BlocBuilder can compare
  // this single int (O(1)) rather than deep-comparing full asset lists (O(n)).
  final int _tick;

  MarketLoaded copyWith({
    List<MarketAsset>? allAssets,
    List<MarketAsset>? filteredAssets,
    AssetCategory? activeFilter,
    bool clearFilter = false,
    String? searchQuery,
    MarketSortType? sortType,
    bool incrementTick = false,
  }) {
    return MarketLoaded(
      allAssets:      allAssets      ?? this.allAssets,
      filteredAssets: filteredAssets ?? this.filteredAssets,
      activeFilter:   clearFilter ? null : (activeFilter ?? this.activeFilter),
      searchQuery:    searchQuery    ?? this.searchQuery,
      sortType:       sortType       ?? this.sortType,
      tick:           incrementTick ? _tick + 1 : _tick,
    );
  }

  @override
  List<Object?> get props => [_tick, activeFilter, searchQuery, sortType];
}

final class MarketError extends MarketState {
  const MarketError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
