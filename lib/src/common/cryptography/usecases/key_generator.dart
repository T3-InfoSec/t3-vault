import 'dart:math';

class KeyGenerator {

  KeyGenerator();

  /// Generates a secure random hexadecimal key, formatted into 4-character blocks
  /// separated by spaces for readability.
  ///
  /// Generates a 32-charater hexadecimal secuence.
  /// Then formats the hexadecimal key into 4-character blocks separated by spaces, for that
  /// uses `replaceAllMapped` with the regex pattern `.{4}`, which matches every group of 4 characters.
  /// For each 4-character match, a space is appended and calls `trim()` to remove any trailing spaces.
  String generateHexadecimalKey() {
    final random = Random.secure();
    final buffer = StringBuffer();
    
    for (int i = 0; i < 32; i++) {
      buffer.write(random.nextInt(16).toRadixString(16));
    }

    return buffer.toString().toUpperCase().replaceAllMapped(
      RegExp(r".{4}"), (match) => "${match.group(0)} ",
    ).trim();
  }
}
