import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Sa0MnemonicPromtWidget extends StatelessWidget {
  final String sa0Mnemonic;

  const Sa0MnemonicPromtWidget({super.key, required this.sa0Mnemonic});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black;

    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.sa0WidgetTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            sa0Mnemonic,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: AppLocalizations.of(context)!.sa0Description1, style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: AppLocalizations.of(context)!.sa0Description2),
                TextSpan(text: AppLocalizations.of(context)!.sa0Description3),
                TextSpan(text: AppLocalizations.of(context)!.sa0Description4),
                TextSpan(text: AppLocalizations.of(context)!.sa0Description5),
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
          child: Text(AppLocalizations.of(context)!.ok),
        ),
      ],
    );
  }
}
