import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:t3_memassist/memory_assistant.dart';
import 'package:t3_vault/src/common/settings/presentation/pages/settings_page.dart';

/// A page for practice eka memory card.
///
/// The [EkaMemoCardPracticePage] class is a stateless widget that displays
/// a question to help the user remember where their eka is stored.
class EkaMemoCardPracticePage extends StatelessWidget {
  static const routeName = 'eka_practice';

  final MemoCard memoCard;

  const EkaMemoCardPracticePage({
    super.key,
    required this.memoCard,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.ekaMemoCardPracticePageTitle),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                context.go('/${SettingsPage.routeName}');
              },
            ),
          ],
        ),
        body: Center(
          child: Text(
            memoCard.knowledge['eka'],
          ),
        ));
  }
}
