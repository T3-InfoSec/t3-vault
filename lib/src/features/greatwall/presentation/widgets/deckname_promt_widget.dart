import 'dart:math';

import 'package:flutter/material.dart';

class DecknamePromtWidget extends StatelessWidget {
  final List<String> hints = [
    'retirement wallet', 'savings for the wedding wallet', 'car savings wallet', 'house down payment wallet',
    'emergency fund wallet', 'gift for my fiancée wallet', 'kids college fund wallet', 'vacation fund wallet', 
    'digital identity recovery key', 'personal development fund wallet'
  ];
  
  DecknamePromtWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();

    return AlertDialog(
      title: const Text('Choose a name for this derivation.'),
      content: TextField(
        controller: passwordController,
        decoration: InputDecoration(hintText: hints[Random().nextInt(hints.length)]),
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
            Navigator.of(context).pop(passwordController.text);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
