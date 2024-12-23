import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:t3_memassist/memory_assistant.dart';
import 'package:t3_vault/src/common/notifications/state/notifications_state.dart';
import 'package:t3_vault/src/features/memorization_assistant/domain/converters/memo_card_json_converter.dart';
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
  static const routeName = '/decks';

  const MemoCardDecksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    final notificationHistory = context.watch<NotificationsState>().notificationHistory;
    Set<String> deckIdsToReview = getNotificationDeckIds(notificationHistory);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MemoCardSetBloc>().add(MemoCardSetLoadRequested());
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.memoCardDecksPageTitle),
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
                  return Text(AppLocalizations.of(context)!.noMemoCards);
                }

                Map<String, List<MemoCard>> memoCardsByDeck = {};
                for (var memoCard in memoCardSetState.memoCardSet) {
                  var deckId = memoCard.deck.id;
                  if (!memoCardsByDeck.containsKey(deckId)) {
                    memoCardsByDeck[deckId] = [];
                  }
                  memoCardsByDeck[deckId]!.add(memoCard);
                }

                return BlocBuilder<MemoCardRatingBloc, MemoCardRatingState>(
                  builder: (context, ratingState) {
                    return Wrap(
                      spacing: 5.0,
                      runSpacing: 5.0,
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: memoCardsByDeck.entries.map((deck) {
                        var cards = deck.value;

                        return GestureDetector(
                          onTap: () {
                            context.go(
                              '${MemoCardDecksPage.routeName}/${MemoCardsPage.routeName}',
                              extra: cards,
                            );
                          },
                          child: DeckViewerWidget(
                            themeData: themeData,
                            name: cards[0].deck.name,
                            cardsNum: cards.length,
                            toBeReviewed: deckIdsToReview.contains(deck.key),
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

  Set<String> getNotificationDeckIds(List<NotificationResponse> notificationHistory) {
    return notificationHistory
        .where((response) => response.payload != null)
        .map((response) => response.payload!)
        .map((payload) => jsonDecode(payload))
        .map((json) => MemoCardConverter.extractDeckIdFromJson(json))
        .whereType<String>()
        .toSet(); 
  }
}
