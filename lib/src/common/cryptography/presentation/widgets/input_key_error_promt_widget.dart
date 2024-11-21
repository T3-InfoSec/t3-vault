import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InputKeyErrorPromtWidget extends StatelessWidget {
  const InputKeyErrorPromtWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.inputKeyErrorWidgetTitle),
      content: Text(AppLocalizations.of(context)!.inputKeyErrorDescription),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(AppLocalizations.of(context)!.ok),
        ),
      ],
    );
  }
}
