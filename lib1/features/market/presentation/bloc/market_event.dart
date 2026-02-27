import 'package:equatable/equatable.dart';
import '../../domain/entities/market_asset.dart';

// IMPORTANT: _SearchApplied is declared here (same file as the sealed class)
// because sealed classes in Dart can only be extended/implemented within the
// same library. Placing it here keeps the sealed contract intact while letting
// MarketBloc emit debounced search results through the normal event queue.

/// Sealed base — exhaustive switch without a default branch is enforced by
/// the Dart analyser, making unhandled event additions a compile-time error.
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

  // Deliberately empty: Equatable would do an O(n) deep-compare on every
  // 500 ms tick across all assets. The BLoC event queue is sequential, so
  // we never need equality to deduplicate price-update events.
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

/// Internal event emitted by the 300 ms debounce timer inside [MarketBloc].
///
/// Using an internal event (instead of calling emit() from a Timer callback)
/// keeps all state mutations inside the BLoC event queue — preventing race
/// conditions if the user types and a price tick arrives simultaneously.
///
/// Declared here so it is part of the same sealed library as [MarketEvent].
final class MarketSearchApplied extends MarketEvent {
  final List<MarketAsset> filteredAssets;
  final String query;
  const MarketSearchApplied({required this.filteredAssets, required this.query});
  // No props: this event is fire-and-forget, never compared for equality.
  @override
  List<Object?> get props => [];
}

enum MarketSortType { priceAsc, priceDesc, changeAsc, changeDesc, nameAsc }
