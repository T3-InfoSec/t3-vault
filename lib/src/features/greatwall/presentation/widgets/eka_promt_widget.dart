import 'package:flutter/material.dart';

class EKAPromptWidget extends StatelessWidget {
  final String eka;

  const EKAPromptWidget({super.key, required this.eka});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("This is your key:"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            eka,
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
            Navigator.of(context).pop(eka);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
