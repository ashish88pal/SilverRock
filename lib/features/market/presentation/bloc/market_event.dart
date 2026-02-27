import 'package:equatable/equatable.dart';
import '../../domain/entities/market_asset.dart';

// Sealed so the compiler enforces exhaustive matching — adding a new event
// subtype without handling it is a compile error.
sealed class MarketEvent extends Equatable {
  const MarketEvent();

  @override
  List<Object?> get props => [];
}

final class MarketStarted extends MarketEvent {
  const MarketStarted();
}

final class MarketAssetsUpdated extends MarketEvent {
  final List<MarketAsset> assets;
  const MarketAssetsUpdated(this.assets);

  // Empty props: deep-comparing 12 assets every 500 ms is expensive and
  // unnecessary — the BLoC event queue is sequential so deduplication is
  // not needed here.
  @override
  List<Object?> get props => [];
}

final class MarketFilterChanged extends MarketEvent {
  final AssetCategory? category;
  const MarketFilterChanged(this.category);

  @override
  List<Object?> get props => [category];
}

final class MarketSearchQueryChanged extends MarketEvent {
  final String query;
  const MarketSearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

final class MarketSortChanged extends MarketEvent {
  final MarketSortType sortType;
  const MarketSortChanged(this.sortType);

  @override
  List<Object?> get props => [sortType];
}

// Internal event emitted by the search debounce timer.
// Using an event (not a direct emit from a Timer) keeps all state mutations
// on the BLoC event queue, preventing race conditions with price ticks.
// Declared in this file because sealed subtypes must share a library.
final class MarketSearchApplied extends MarketEvent {
  final List<MarketAsset> filteredAssets;
  final String query;
  const MarketSearchApplied({required this.filteredAssets, required this.query});

  @override
  List<Object?> get props => [];
}

enum MarketSortType { priceAsc, priceDesc, changeAsc, changeDesc, nameAsc }
