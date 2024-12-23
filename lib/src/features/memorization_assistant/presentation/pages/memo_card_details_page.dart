import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:t3_memassist/memory_assistant.dart';

import 'package:t3_vault/src/features/memorization_assistant/domain/strategies/factory_memo_card_strategy.dart';
import 'package:t3_vault/src/features/memorization_assistant/domain/strategies/memo_card_strategy.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/pages/memo_card_decks_page.dart';

import '../../../../common/settings/presentation/pages/settings_page.dart';
import '../blocs/blocs.dart';

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
    final MemoCardStrategy strategy =
        MemoCardStrategyFactory.getStrategy(memoCard);

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
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: themeData.colorScheme.primary,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    memoCard.title,
                    style: TextStyle(
                      fontSize: themeData.textTheme.titleLarge!.fontSize,
                          fontWeight:
                              themeData.textTheme.titleLarge!.fontWeight,
                          color: themeData.colorScheme.onPrimary,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'State: ${memoCard.state}',
                    style: TextStyle(
                      fontSize: themeData.textTheme.bodySmall!.fontSize,
                      fontWeight: themeData.textTheme.bodySmall!.fontWeight,
                      color: themeData.colorScheme.onPrimary,
                    ),
                  ),
                  Text(
                    'Due: ${memoCard.due.toLocal()}',
                    style: TextStyle(
                      fontSize: themeData.textTheme.bodySmall!.fontSize,
                      fontWeight: themeData.textTheme.bodySmall!.fontWeight,
                      color: themeData.colorScheme.onPrimary,
                    ),
                  ),
                ],
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
            if (strategy.buildRecoveryButton(context, memoCard) != null)
              strategy.buildRecoveryButton(context, memoCard)!,
            const SizedBox(height: 10),
            strategy.buildTryButton(context, memoCard),

          ],
        ),
      ),
    );
  }
}
