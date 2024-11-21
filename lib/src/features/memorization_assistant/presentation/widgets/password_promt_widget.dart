import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PasswordPrompt extends StatelessWidget {
  const PasswordPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();

    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.secretWidgetTitle),
      content: TextField(
        controller: passwordController,
        obscureText: true,
        decoration: InputDecoration(hintText: AppLocalizations.of(context)!.secretHint),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(passwordController.text);
          },
          child: Text(AppLocalizations.of(context)!.ok),
        ),
      ],
    );
  }
}
