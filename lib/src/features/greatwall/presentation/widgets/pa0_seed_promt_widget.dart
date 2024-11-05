import 'package:flutter/material.dart';

class Pa0SeedPromtWidget extends StatelessWidget {
  final String pa0Seed;

  const Pa0SeedPromtWidget({super.key, required this.pa0Seed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("This is your seed:"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            pa0Seed,
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
                TextSpan(text: "Write down and store your 6-word seed in a safe place.\n", style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: "These words are used as input for the derivation protocol. "),
                TextSpan(text: "If lost, you won't be able to retrieve the key directly. However, you can recover your seed using this ephemeral key, which is provided as you save the protocol.\n\n"),
                TextSpan(text: "Over time, you can memorize the seed with the help of the memorization assistant, but for now, keeping it safe is a top priority.\n\n"),
                TextSpan(text: "While 12-word seeds (128 bits of entropy) provide higher security, a 6-word seed (64 bits) is sufficient when used with the Tacit Knowledge Base Authentication process, which adds another 64 bits of entropy for a total of 128 bits."),
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
          child: const Text('OK'),
        ),
      ],
    );
  }
}
