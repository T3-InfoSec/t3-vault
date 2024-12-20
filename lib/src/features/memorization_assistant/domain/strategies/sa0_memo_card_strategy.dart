import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:t3_crypto_objects/crypto_objects.dart';

import 'package:t3_memassist/memory_assistant.dart';

import 'package:t3_vault/src/common/cryptography/presentation/widgets/input_key_error_promt_widget.dart';
import 'package:t3_vault/src/common/cryptography/presentation/widgets/password_promt_widget.dart';
import 'package:t3_vault/src/common/cryptography/presentation/widgets/sa0_mnemonic_promt_widget.dart';

import 'package:t3_vault/src/features/memorization_assistant/domain/strategies/memo_card_strategy.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/pages/memo_card_decks_page.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/pages/sa0_memo_card_practice_page.dart';

class Sa0MemoCardStrategy extends MemoCardStrategy {
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
            String sa0Mnemonic = await decryptSa0Mnemonic(key, memoCard);
            if (!context.mounted) return;
            await showDialog<String>(
              context: context,
              builder: (context) =>
                  Sa0MnemonicPromtWidget(sa0Mnemonic: sa0Mnemonic),
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
        
        String sa0Mnemonic = await decryptSa0Mnemonic(key, memoCard);

        if (!context.mounted) return;
        context.go(
          '${MemoCardDecksPage.routeName}/${Sa0MemoCardPracticePage.routeName}',
          extra: {
            'memoCard': memoCard,
            'sa0Mnemonic': sa0Mnemonic,
          },
        );
      },
      child: Text(AppLocalizations.of(context)!.tryCard),
    );
  }

  Future<String> decryptSa0Mnemonic(String key, MemoCard memoCard) async {
    final eka = Eka.fromKey(key);

    var sa0MemoCard = (memoCard as Sa0MemoCard);
    var critical = await eka.decrypt(base64Decode(sa0MemoCard.encryptedSa0));
    Sa0 sa0 = Sa0(Formosa(critical.value, FormosaTheme.bip39));

    return sa0.formosa.mnemonic;
  }
}
