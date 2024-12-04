import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:t3_memassist/memory_assistant.dart';
import 'package:great_wall/great_wall.dart';

import 'package:t3_vault/src/common/cryptography/presentation/widgets/sa0_seed_promt_widget.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/pages/memo_card_decks_page.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/pages/memo_card_practice_page.dart';
import 'package:t3_vault/src/common/cryptography/presentation/widgets/input_key_error_promt_widget.dart';
import 'package:t3_vault/src/common/cryptography/presentation/widgets/password_promt_widget.dart';

import '../../../../common/settings/presentation/pages/settings_page.dart';
import '../../../greatwall/presentation/blocs/blocs.dart';
import '../blocs/blocs.dart';
import '../widgets/widgets.dart';

/// A page that displays the detailed view of a specific memory card.
///
/// The [CardDetailsPage] class is a stateless widget that shows the
/// details of a selected [memoCard], including its state and due date.
class MemoCardDetailsPage extends StatelessWidget {
  static const routeName = 'details';

  final MemoCard memoCard;

  /// Creates a detailed view of a memory card.
  ///
  /// receives [memoCard] to provide the card's data.
  const MemoCardDetailsPage({
    super.key,
    required this.memoCard,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.memoCardDetailsPageTitle),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: themeData.colorScheme.primary,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: BlocBuilder<MemoCardRatingBloc, MemoCardRatingState>(
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        style: TextStyle(
                          fontSize: themeData.textTheme.titleLarge!.fontSize,
                          fontWeight:
                              themeData.textTheme.titleLarge!.fontWeight,
                          color: themeData.colorScheme.onPrimary,
                        ),
                        memoCard.title,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        style: TextStyle(
                          fontSize: themeData.textTheme.bodySmall!.fontSize,
                          fontWeight: themeData.textTheme.bodySmall!.fontWeight,
                          color: themeData.colorScheme.onPrimary,
                        ),
                        'State: ${memoCard.state}',
                      ),
                      Text(
                        style: TextStyle(
                          fontSize: themeData.textTheme.bodySmall!.fontSize,
                          fontWeight: themeData.textTheme.bodySmall!.fontWeight,
                          color: themeData.colorScheme.onPrimary,
                        ),
                        'Due: ${memoCard.due.toLocal()}',
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        alignment: WrapAlignment.center,
                        children: [
                          RatingButton(
                            memoCard: memoCard,
                            themeData: themeData,
                            text: AppLocalizations.of(context)!.again,
                          ),
                          RatingButton(
                            memoCard: memoCard,
                            themeData: themeData,
                            text: AppLocalizations.of(context)!.hard,
                          ),
                          RatingButton(
                            memoCard: memoCard,
                            themeData: themeData,
                            text: AppLocalizations.of(context)!.good,
                          ),
                          RatingButton(
                            memoCard: memoCard,
                            themeData: themeData,
                            text: AppLocalizations.of(context)!.easy,
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            BlocBuilder<MemoCardSetBloc, MemoCardSetState>(
              builder: (context, memoCardSetState) {
                return ElevatedButton(
                  onPressed: () {
                    context.read<MemoCardSetBloc>().add(
                          MemoCardSetCardRemoved(memoCard: memoCard),
                        );
                    context.go(MemoCardDecksPage.routeName);
                  },
                  child: Text(AppLocalizations.of(context)!.deleteMemoCard),
                );
              },
            ),
            const SizedBox(height: 10),
            if (memoCard is TacitKnowledgeMemoCard)
              ElevatedButton(
                onPressed: () async {
                  String? key = await showDialog<String>(
                    context: context,
                    builder: (context) => const PasswordPrompt(),
                  );

                  if (key != null && key.isNotEmpty && await isValid(key)) {
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
                        sa0Mnemonic: 'not needed sa0 for practice level',
                      ),
                    );
                    context.go(
                      '${MemoCardDecksPage.routeName}/${MemoCardPracticePage.routeName}',
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
              )
            else if (memoCard is Sa0MemoCard)
              ElevatedButton(
                onPressed: () async {
                  Sa0MemoCard sa0MemoCard = memoCard as Sa0MemoCard;
                  String? key = await showDialog<String>(
                    context: context,
                    builder: (context) => const PasswordPrompt(),
                  );

                  if (key != null && key.isNotEmpty) {
                    try {
                      final eka = Eka.fromKey(key);
                      Sa0 sa0 = await eka.decrypt(base64Decode(sa0MemoCard.sa0)) as Sa0;
                      if (!context.mounted) return;
                      await showDialog<String>(
                        context: context,
                        builder: (context) => Sa0MnemonicPromtWidget(sa0Mnemonic: sa0.formosa.mnemonic),
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
              ),
          ],
        ),
      ),
    );
  }
  
  Future<bool> isValid(String key) async {
    Eka eka = Eka.fromKey(key);
    try {
      await eka.decrypt(memoCard.knowledge['node']);
      return true;
    } catch (e) {
      debugPrint('Error decryting node: $e');
      return false;
    }
  }
}
