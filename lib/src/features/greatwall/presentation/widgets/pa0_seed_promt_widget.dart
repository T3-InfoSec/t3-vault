import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:t3_formosa/formosa.dart';

class Pa0SeedPromtWidget extends StatelessWidget {
  const Pa0SeedPromtWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Formosa formosa = Formosa(formosaTheme: FormosaTheme.bip39);
    Uint8List randomEntropy = Uint8List(8);
    Random random = Random();
    for (int i = 0; i < randomEntropy.length; i++) {
      randomEntropy[i] =
          random.nextInt(256); // Generates a number between 0 and 255
    }
    String sixWordsSeed = formosa.toFormosa(randomEntropy);

    return AlertDialog(
      title: const Text("This is your seed:"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            sixWordsSeed,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 16),
          RichText(
            text: const TextSpan(
              //style: TextStyle(color: Colors.black),
              children: [
                TextSpan(text: "Important: ", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                TextSpan(text: "While 12-word seeds (128 bits of entropy) provide higher security, a 6-word seed (64 bits) is sufficient when used with the Tacit Knowledge Base Authentication process, which adds another 64 bits of entropy for a total of 128 bits.\n"),
                TextSpan(text: "It's crucial to "),
                TextSpan(text: "write down and store your 6-word seed in a safe place. ", style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: "These words are essential for deriving the final key. If lost, you won't be able to retrieve the key. Over time, you can memorize the seed with the help of the memorization assistant, but for now, keeping it safe is a top priority."),
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
            Navigator.of(context).pop(sixWordsSeed);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
