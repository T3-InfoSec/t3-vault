import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Pa0SeedPromtWidget extends StatelessWidget {
  final String pa0Seed;

  const Pa0SeedPromtWidget({super.key, required this.pa0Seed});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black;

    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.chooseNameWidgetTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            pa0Seed,
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
                TextSpan(text: AppLocalizations.of(context)!.pa0Description1, style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: AppLocalizations.of(context)!.pa0Description2),
                TextSpan(text: AppLocalizations.of(context)!.pa0Description3),
                TextSpan(text: AppLocalizations.of(context)!.pa0Description4),
                TextSpan(text: AppLocalizations.of(context)!.pa0Description5),
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
