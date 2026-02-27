import 'package:equatable/equatable.dart';

/// Base failure type.
///
/// Sealed so the Dart analyser enforces exhaustive pattern matching on every
/// switch over a [Failure] value — no unhandled failure types at compile time.
sealed class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

/// Failure originating from a data layer operation (network, DB, parse error).
final class DataFailure extends Failure {
  const DataFailure(super.message);
}

/// Failure in the market price simulation engine.
final class SimulationFailure extends Failure {
  const SimulationFailure(super.message);
}
