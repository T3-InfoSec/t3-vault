import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:t3_memassist/memory_assistant.dart';
import 'package:t3_vault/src/features/memorization_assistant/domain/strategies/memo_card_strategy.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/pages/eka_memo_card_practice_page.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/pages/memo_card_decks_page.dart';

class EkaMemoCardStrategy extends MemoCardStrategy {
  @override
  Widget? buildRecoveryButton(BuildContext context, MemoCard memoCard) {
    return null; // Not required for Eka Memo Card
  }

  @override
  Widget buildTryButton(BuildContext context, MemoCard memoCard) {
    return ElevatedButton(
      onPressed: () {
        context.go(
          '${MemoCardDecksPage.routeName}/${EkaMemoCardPracticePage.routeName}',
          extra: {
            'memoCard': memoCard,
          },
        );
      },
      child: Text(AppLocalizations.of(context)!.tryCard),
    );
  }
}
