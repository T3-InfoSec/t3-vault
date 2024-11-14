import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PasswordPrompt extends StatelessWidget {
  const PasswordPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();
    final ValueNotifier<bool> isObscuredNotifier = ValueNotifier<bool>(true);

    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.secretWidgetTitle),
      content: ValueListenableBuilder<bool>(
        valueListenable: isObscuredNotifier,
        builder: (context, isObscured, child) {
          return TextField(
            controller: passwordController,
            obscureText: isObscured,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.secretHint,
              suffixIcon: IconButton(
                icon: Icon(
                  isObscured ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  isObscuredNotifier.value = !isObscuredNotifier.value;
                },
              ),
            ),
          );
        },
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
