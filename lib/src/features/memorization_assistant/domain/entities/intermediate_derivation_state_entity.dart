/// Represents an intermediate state with additional fields.
class IntermediateDerivationStateEntity {
  final String value;
  final int currentIteration;
  final int totalIterations;

  IntermediateDerivationStateEntity({
    required this.value,
    required this.currentIteration,
    required this.totalIterations,
  });
}
