import 'dart:math';

import 'package:flutter/material.dart';

class EKAPromptWidget extends StatelessWidget {
  const EKAPromptWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final generatedKey = generateHexadecimalKey();

    return AlertDialog(
      title: const Text("This is your key:"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            generatedKey,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 16),
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(text: "Important, ", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                TextSpan(text: "make a physical backup of this key by writing it down and storing it in a secure place.\n"),
                TextSpan(text: "This key cannot be recovered if lost.", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(generatedKey);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }

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
