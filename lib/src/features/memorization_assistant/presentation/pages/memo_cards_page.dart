import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:t3_memassist/memory_assistant.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/pages/memo_card_decks_page.dart';

import '../../../../common/settings/presentation/pages/settings_page.dart';
import '../widgets/widgets.dart';
import 'memo_card_details_page.dart';

/// A page for showing memory cards.
///
/// The [MemoCardsPage] class is a stateless widget that displays a
/// collection of memory cards, which users can interact with to review their
/// tacit knowledge protocol.
class MemoCardsPage extends StatelessWidget {
  static const routeName = 'memo_cards';

  final List<MemoCard> memoCards;

  /// Creates all memo cards of a deck view.
  ///
  /// [memoCards] all cards from a deck
  const MemoCardsPage({
    super.key, 
    required this.memoCards
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Memorization Cards'),
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
            child: memoCards.isEmpty 
            ? const Text('No Memorization Cards in this deck!') 
            : Wrap(
                spacing: 5.0,
                runSpacing: 5.0,
                direction: Axis.horizontal,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: memoCards.asMap().entries.map(
                  (entry) {
                    int levelNumber = entry.key;
                    MemoCard memoCard = entry.value;
                    return GestureDetector(
                      onTap: () {
                        context.go(
                          '/${MemoCardDecksPage.routeName}/${MemoCardDetailsPage.routeName}/$levelNumber',
                          extra: memoCard,
                        );
                      },
                      child: MemoCardViewer(
                        themeData: themeData,
                        memoCard: memoCard,
                      ),
                    );
                  },
                ).toList(),
              ),
          ),
        ),
      ),
    );
  }
}