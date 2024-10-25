import 'package:flutter/material.dart';

class PasswordPrompt extends StatelessWidget {
  const PasswordPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();

    return AlertDialog(
      title: const Text('Enter Password'),
      content: TextField(
        controller: passwordController,
        obscureText: true,
        decoration: const InputDecoration(hintText: 'Password'),
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
