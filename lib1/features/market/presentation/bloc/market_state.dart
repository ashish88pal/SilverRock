import 'package:equatable/equatable.dart';
import '../../domain/entities/market_asset.dart';
import 'market_event.dart';

/// Sealed: exhaustive pattern matching in all switch/if-chains.
/// Every substate is final — cannot be subclassed outside this library.
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
  final List<MarketAsset> allAssets;
  final List<MarketAsset> filteredAssets;
  final AssetCategory? activeFilter;
  final String searchQuery;
  final MarketSortType sortType;

  /// Monotonic counter incremented on every price tick.
  /// BlocBuilder compares this single int (O(1)) instead of deep-comparing
  /// two full List<MarketAsset> (O(n)) on every 500 ms tick.
  final int _tick;

  const MarketLoaded({
    required this.allAssets,
    required this.filteredAssets,
    this.activeFilter,
    this.searchQuery = '',
    this.sortType = MarketSortType.priceDesc,
    int tick = 0,
  }) : _tick = tick;

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
      allAssets: allAssets ?? this.allAssets,
      filteredAssets: filteredAssets ?? this.filteredAssets,
      activeFilter: clearFilter ? null : (activeFilter ?? this.activeFilter),
      searchQuery: searchQuery ?? this.searchQuery,
      sortType: sortType ?? this.sortType,
      tick: incrementTick ? _tick + 1 : _tick,
    );
  }

  @override
  List<Object?> get props => [_tick, activeFilter, searchQuery, sortType];
}

final class MarketError extends MarketState {
  final String message;

  const MarketError(this.message);

  @override
  List<Object?> get props => [message];
}
