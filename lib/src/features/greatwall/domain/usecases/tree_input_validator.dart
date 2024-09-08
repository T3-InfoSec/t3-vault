class TreeInputValidator {
  static String? validateArity(String value) {
    final int? arity = int.tryParse(value);
    if (arity == null || arity < 2 || arity > 256) {
      return 'Choose tree arity from 2 to 256';
    }
    return null;
  }

  static String? validateDepth(String value) {
    final int? depth = int.tryParse(value);
    if (depth == null || depth < 1 || depth > 256) {
      return 'Choose tree depth from 1 to 256';
    }
    return null;
  }

  static String? validateTimeLock(String value) {
    final int? timeLock = int.tryParse(value);
    if (timeLock == null || timeLock < 1 || timeLock > 2016) {
      return 'Choose TLP param from 1 to 2016';
    }
    return null;
  }
}
