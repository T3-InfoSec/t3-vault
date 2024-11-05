import 'package:flutter/material.dart';

class DecryptionErrorPromtWidget extends StatelessWidget {
  const DecryptionErrorPromtWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Error"),
      content: const Text("The provided key is incorrect. Please try again."),
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
