import 'package:flutter/material.dart';

class EKAPromptWidget extends StatelessWidget {
  final String eka;

  const EKAPromptWidget({super.key, required this.eka});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black;

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
            text: TextSpan(
              children: const [
                TextSpan(text: "Important, ", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                TextSpan(text: "make a physical backup of this key by writing it down and storing it in a secure place.\n", style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: "This key cannot be recovered if lost.", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
              style: TextStyle(color: textColor),
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
