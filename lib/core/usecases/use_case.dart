// Four narrow interfaces — one for each combination of
// (async/stream) × (params/no-params).
//
// BLoCs and tests depend on these abstract types, never on concrete classes.
// Swap any implementation without touching callers.

abstract interface class FutureUseCase<Type, Params> {
  Future<Type> call(Params params);
}

abstract interface class FutureNoParamsUseCase<Type> {
  Future<Type> call();
}

abstract interface class StreamUseCase<Type, Params> {
  Stream<Type> call(Params params);
}

abstract interface class StreamNoParamsUseCase<Type> {
  Stream<Type> call();
}
