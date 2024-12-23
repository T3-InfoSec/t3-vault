import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DecknamePromtWidget extends StatelessWidget {
  
  const DecknamePromtWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> hints = [
      AppLocalizations.of(context)!.hint1,
      AppLocalizations.of(context)!.hint2,
      AppLocalizations.of(context)!.hint3,
      AppLocalizations.of(context)!.hint4,
      AppLocalizations.of(context)!.hint5,
      AppLocalizations.of(context)!.hint6,
      AppLocalizations.of(context)!.hint7,
      AppLocalizations.of(context)!.hint8,
      AppLocalizations.of(context)!.hint9,
      AppLocalizations.of(context)!.hint10,
    ];
    final TextEditingController passwordController = TextEditingController();

    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.chooseNameWidgetTitle),
      content: TextField(
        controller: passwordController,
        decoration: InputDecoration(hintText: hints[Random().nextInt(hints.length)]),
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
