import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EKAPromptWidget extends StatelessWidget {
  final String eka;

  const EKAPromptWidget({super.key, required this.eka});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.ekaWidgetTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            eka,
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
                TextSpan(text: AppLocalizations.of(context)!.ekaDescription1, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                TextSpan(text: AppLocalizations.of(context)!.ekaDescription2),
                TextSpan(text: AppLocalizations.of(context)!.ekaDescription3, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
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
            Navigator.of(context).pop(eka);
          },
          child: Text(AppLocalizations.of(context)!.ok),
        ),
      ],
    );
  }
}
