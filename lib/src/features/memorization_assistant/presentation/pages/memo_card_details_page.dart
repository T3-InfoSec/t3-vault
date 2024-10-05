import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:great_wall/great_wall.dart';
import 'package:t3_memassist/memory_assistant.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/pages/memo_cards_page.dart';

import '../../../../common/settings/presentation/pages/settings_page.dart';
import '../../../greatwall/presentation/blocs/blocs.dart';
import '../../../greatwall/presentation/pages/confirmation_page.dart';
import '../blocs/blocs.dart';
import '../widgets/widgets.dart';

/// A page that displays the detailed view of a specific memory card.
///
/// The [CardDetailsPage] class is a stateless widget that shows the
/// details of a selected [memoCard], including its state and due date.
class MemoCardDetailsPage extends StatelessWidget {
  static const routeName = 'memo_card_details';

  final int cardName;
  final MemoCard memoCard;

  /// Creates a detailed view of a memory card.
  ///
  /// [cardName] identify the position of the card in the knowledge
  /// tree and [memoCard] to provide the card's data.
  const MemoCardDetailsPage({
    super.key,
    required this.cardName,
    required this.memoCard,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Details'),
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
                        'L$cardName Card Details',
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RatingButton(
                            memoCard: memoCard,
                            themeData: themeData,
                            text: 'Again',
                          ),
                          RatingButton(
                            memoCard: memoCard,
                            themeData: themeData,
                            text: 'Hard',
                          ),
                          RatingButton(
                            memoCard: memoCard,
                            themeData: themeData,
                            text: 'Good',
                          ),
                          RatingButton(
                            memoCard: memoCard,
                            themeData: themeData,
                            text: 'Easy',
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
                    context.go('/${MemoCardsPage.routeName}');
                  },
                  child: const Text('Delete Memorization Card'),
                );
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                int treeArity = memoCard.knowledge['treeArity'];
                int treeDepth = memoCard.knowledge['treeDepth'];
                int timeLock = memoCard.knowledge['timeLockPuzzleParam'];
                TacitKnowledge tacitKnowledge =
                    memoCard.knowledge['tacitKnowledge'];
                String secretSeed = memoCard.knowledge['secretSeed'];

                context.read<GreatWallBloc>().add(
                      GreatWallInitialized(
                        treeArity: treeArity,
                        treeDepth: treeDepth,
                        timeLockPuzzleParam: timeLock,
                        tacitKnowledge: tacitKnowledge,
                        secretSeed: secretSeed,
                      ),
                    );
                context.go('/${ConfirmationPage.routeName}');
              },
              child: const Text('Try protocol'),
            ),
          ],
        ),
      ),
    );
  }
}
