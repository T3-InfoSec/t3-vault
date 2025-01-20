/// Represents an intermediate state with additional fields.
class IntermediateDerivationStateEntity {
  final String encryptedValue;
  final int currentIteration;
  final int totalIterations;

  IntermediateDerivationStateEntity({
    required this.encryptedValue,
    required this.currentIteration,
    required this.totalIterations,
  });
}
