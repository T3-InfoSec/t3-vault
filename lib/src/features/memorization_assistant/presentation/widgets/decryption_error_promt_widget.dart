import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DecryptionErrorPromtWidget extends StatelessWidget {
  const DecryptionErrorPromtWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.decryptionErrorWidgetTitle),
      content: Text(AppLocalizations.of(context)!.decryptionErrorDescription),
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
