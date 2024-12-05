import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:great_wall/great_wall.dart';
import 'package:t3_memassist/memory_assistant.dart';
import 'package:t3_vault/src/common/cryptography/presentation/widgets/input_key_error_promt_widget.dart';
import 'package:t3_vault/src/common/cryptography/presentation/widgets/pa0_seed_promt_widget.dart';
import 'package:t3_vault/src/common/cryptography/presentation/widgets/password_promt_widget.dart';
import 'package:t3_vault/src/features/memorization_assistant/domain/strategies/memo_card_strategy.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/pages/memo_card_decks_page.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/pages/pa0_memo_card_practice_page.dart';

class Pa0MemoCardStrategy extends MemoCardStrategy {
  @override
  Widget? buildRecoveryButton(BuildContext context, MemoCard memoCard) {
    return ElevatedButton(
      onPressed: () async {
        String? key = await showDialog<String>(
          context: context,
          builder: (context) => const PasswordPrompt(),
        );

        if (key != null && key.isNotEmpty) {
          try {
            final eka = Eka(key: key);
            Pa0 pa0 = await eka.decryptToPa0((memoCard as Pa0MemoCard).pa0);
            if (!context.mounted) return;
            await showDialog<String>(
              context: context,
              builder: (context) => Pa0SeedPromtWidget(pa0Seed: pa0.seed),
            );
          } catch (e) {
            if (!context.mounted) return;
            await showDialog<String>(
              context: context,
              builder: (context) => const InputKeyErrorPromtWidget(),
            );
          }
        }
      },
      child: Text(AppLocalizations.of(context)!.passwordRecovery),
    );
  }

  @override
  Widget buildTryButton(BuildContext context, MemoCard memoCard) {
    return ElevatedButton(
      onPressed: () async {
        String? key = await showDialog<String>(
          context: context,
          builder: (context) => const PasswordPrompt(),
        );

        if (key == null || key.isEmpty) {
          if (!context.mounted) return;
          await showDialog<String>(
            context: context,
            builder: (context) => const InputKeyErrorPromtWidget(),
          );
          return;
        }

        Pa0? pa0;
        try {
          final eka = Eka(key: key);
          pa0 = await eka.decryptToPa0((memoCard as Pa0MemoCard).pa0);
        } catch (e) {
          debugPrint('Error decrypting: $e');
          return;
        }

        if (!context.mounted) return;
        context.go(
          '${MemoCardDecksPage.routeName}/${Pa0MemoCardPracticePage.routeName}',
          extra: {
            'pa0Seed': pa0.seed,
          },
        );
      },
      child: Text(AppLocalizations.of(context)!.tryCard),
    );
  }
}
