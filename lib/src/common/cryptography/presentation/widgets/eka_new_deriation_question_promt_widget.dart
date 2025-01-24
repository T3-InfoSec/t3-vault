import 'package:flutter/material.dart';

class EkaNewDeriationQuestionPromtWidget extends StatelessWidget {
  const EkaNewDeriationQuestionPromtWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Is this a new derivation?"),
      content: const Text(""),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text("No. I already have an EKA."),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const Text("Yes. First time for these parameters."),
        ),
      ],
    );
  }
}
