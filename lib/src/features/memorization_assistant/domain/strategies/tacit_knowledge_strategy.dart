import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:go_router/go_router.dart';
import 'package:great_wall/great_wall.dart';
import 'package:t3_memassist/memory_assistant.dart';

import 'package:t3_vault/src/common/cryptography/presentation/widgets/input_key_error_promt_widget.dart';
import 'package:t3_vault/src/common/cryptography/presentation/widgets/password_promt_widget.dart';
import 'package:t3_vault/src/features/greatwall/presentation/blocs/blocs.dart';
import 'package:t3_vault/src/features/memorization_assistant/domain/strategies/memo_card_strategy.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/pages/memo_card_decks_page.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/pages/tacitknowledge_memo_card_practice_page.dart';

class TacitKnowledgeStrategy extends MemoCardStrategy {
  static const _mockSa0Mnemonic = 'steak sea alien improve local clown pipe tip chase parrot unusual valve';

  @override
  Widget? buildRecoveryButton(BuildContext context, MemoCard memoCard) {
    return null; // Not required for Tacit Knowledge Memo Card
  }

  @override
  Widget buildTryButton(BuildContext context, MemoCard memoCard) {
    return ElevatedButton(
      onPressed: () async {
        String? key = await showDialog<String>(
          context: context,
          builder: (context) => const PasswordPrompt(),
        );

        if (key != null && key.isNotEmpty && await isValid(key, memoCard)) {
          int treeArity = memoCard.knowledge['treeArity'];
          int treeDepth = memoCard.knowledge['treeDepth'];
          TacitKnowledge tacitKnowledge = memoCard.knowledge['tacitKnowledge'];

          if (!context.mounted) return;
          context.read<GreatWallBloc>().add(
            GreatWallInitialized(
              treeArity: treeArity,
              treeDepth: treeDepth,
              timeLockPuzzleParam: 1,
              tacitKnowledge: tacitKnowledge,
              sa0Mnemonic: _mockSa0Mnemonic, // not needed sa0 for practice level
            ),
          );
          context.go(
            '${MemoCardDecksPage.routeName}/${TacitKnowledgeMemoCardPracticePage.routeName}',
            extra: {
              'memoCard': memoCard,
              'eka': key,
            },
          );
        } else {
          if (!context.mounted) return;
          await showDialog<String>(
            context: context,
            builder: (context) => const InputKeyErrorPromtWidget(),
          );
        }
      },
      child: Text(AppLocalizations.of(context)!.tryCard),
    );
  }
}
