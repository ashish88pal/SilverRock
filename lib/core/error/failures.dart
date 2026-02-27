import 'package:equatable/equatable.dart';

// Sealed so the compiler enforces exhaustive matching — every switch over a
// Failure must handle all subtypes or it won't compile.
sealed class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

// Failure from a data-layer operation (parse error, missing record, etc.).
final class DataFailure extends Failure {
  const DataFailure(super.message);
}

// Failure in the price simulation engine.
final class SimulationFailure extends Failure {
  const SimulationFailure(super.message);
}
