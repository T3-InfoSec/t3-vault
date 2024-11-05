import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:great_wall/great_wall.dart';
import 'package:t3_memassist/memory_assistant.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/pages/memo_cards_page.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/widgets/deck_viewer_widget.dart';

import '../../../../common/settings/presentation/pages/settings_page.dart';
import '../blocs/blocs.dart';

/// A page for showing memory card decks.
///
/// The [MemoCardDecksPage] class is a stateless widget that displays a
/// collection of memory card decks, which users can interact with to review their
/// tacit knowledge protocol.
class MemoCardDecksPage extends StatelessWidget {
  static const routeName = 'memo_card_decks';

  const MemoCardDecksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MemoCardSetBloc>().add(MemoCardSetLoadRequested());
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Memorization Card Decks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.go('/${SettingsPage.routeName}');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<MemoCardSetBloc, MemoCardSetState>(
              builder: (context, memoCardSetState) {
                if (memoCardSetState.memoCardSet.isEmpty) {
                  return const Text('No Memorization Cards Yet!');
                }

                // Group MemoCards by deck
                Map<String, List<MemoCard>> memoCardsByDeck = {};
                for (var memoCard in memoCardSetState.memoCardSet) {
                  var deck = memoCard.deck;
                  if (!memoCardsByDeck.containsKey(deck)) {
                    memoCardsByDeck[deck] = [];
                  }
                  memoCardsByDeck[deck]!.add(memoCard);
                }

                return BlocBuilder<MemoCardRatingBloc, MemoCardRatingState>(
                  builder: (context, ratingState) {
                    return Wrap(
                      spacing: 5.0,
                      runSpacing: 5.0,
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: memoCardsByDeck.entries.map((entry) {
                        var cards = entry.value;

                        return GestureDetector(
                          onTap: () {
                            context.go(
                              '/$routeName/${MemoCardsPage.routeName}',
                              extra: cards,
                            );
                          },
                          child: DeckViewerWidget(
                            themeData: themeData,
                            name: getDeckName(cards),
                            cardsNum: cards.length,
                          ),
                        );
                      }).toList(),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  String getDeckName(List<MemoCard> cards) {
    var tacitKnowledge = getTacitKnowledgeIfExists(cards);
    String name;
    if (tacitKnowledge != null) {
      if (tacitKnowledge is FormosaTacitKnowledge) {
        name = 'Formosa';
      } else if (tacitKnowledge is HashVizTacitKnowledge) {
        name = 'Hashviz';
      } else {
        name = 'Unknown TacitKnowledge';
      }
    } else {
      name = 'Keys';
    }
    return name;
  }

  dynamic getTacitKnowledgeIfExists(List<MemoCard> memoCards) {
    for (var card in memoCards) {
      if (card is TacitKnowledgeMemoCard) {
        return card.knowledge['tacitKnowledge'];
      }
    }
    return null;
  }
}