import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:t3_memassist/memory_assistant.dart';

import '../../../../core/settings/presentation/pages/settings_page.dart';
import '../../../landing/presentation/pages/home_page.dart';
import 'memo_card_details_page.dart';

/// A page for showing memory cards.
///
/// The [MemoCardsPage] class is a stateless widget that displays a
/// collection of memory cards, which users can interact with to review their
/// tacit knowledge protocol.
class MemoCardsPage extends StatelessWidget {
  static const routeName = 'memo_cards';

  const MemoCardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<MemoCard> memoCards = _createMemoCards();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Memorization Cards'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go(HomePage.routeName);
          },
        ),
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('My Cards'),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
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
                            '/$routeName/${MemoCardDetailsPage.routeName}/$levelNumber',
                            extra: memoCard,
                          );
                        },
                        child: _buildCard('L$levelNumber', memoCard),
                      );
                    },
                  ).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(String title, MemoCard memoCard) {
    return Container(
      width: 200,
      height: 150,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: const Color(0xFF4A6FA5),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title),
          const SizedBox(height: 5),
          Text(
            'Next review:\n${memoCard.due.toLocal()}',
          ),
        ],
      ),
    );
  }

  // TODO Get the memory cards from the derivation protocol.
  List<MemoCard> _createMemoCards() {
    return List.generate(10, (index) {
      MemoCard memoCard = MemoCard(knowledge: 'test');
      memoCard.rateCard(index < 3
          ? "easy"
          : index < 6
              ? "good"
              : "hard");
      if (index == 9) memoCard.rateCard("again");
      return memoCard;
    });
  }
}
