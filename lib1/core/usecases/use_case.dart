/// SOLID / DIP: typed use-case contracts.
///
/// Every concrete use case must implement exactly one of these interfaces.
/// BLoCs depend on these abstract types — not on the concrete classes — so
/// they can be unit-tested with mocks without touching the real repository.
///
/// Interface-Segregation: four narrow interfaces instead of one fat one.
/// Each covers exactly one combination of (sync/async) × (params/no-params).

/// Asynchronous use case that accepts a [Params] argument.
abstract interface class FutureUseCase<Type, Params> {
  Future<Type> call(Params params);
}

/// Asynchronous use case that requires no arguments.
abstract interface class FutureNoParamsUseCase<Type> {
  Future<Type> call();
}

/// Streaming use case that accepts a [Params] argument.
abstract interface class StreamUseCase<Type, Params> {
  Stream<Type> call(Params params);
}

/// Streaming use case that requires no arguments.
abstract interface class StreamNoParamsUseCase<Type> {
  Stream<Type> call();
}
