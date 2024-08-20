import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:t3_vault/src/core/settings/presentation/pages/settings_page.dart';
import 'package:t3_vault/src/features/landing/presentation/pages/home_page.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/pages/card_details_page.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/utils/memo_card_utils.dart';

import 'package:memory_assistant/memory_assistant.dart';

/// A page for showing memory cards.
///
/// The [MemorizationDeckPage] class is a stateless widget that displays a
/// collection of memory cards, which users can interact with to review their
/// tacit knowledge protocol.
class MemorizationDeckPage extends StatelessWidget {
  static const routeName = 'memorization_assistant_deck';

  const MemorizationDeckPage({super.key});

  @override
  Widget build(BuildContext context) {
    // The following variables are harcoded memory cards to be used until the greatwall protocol flow is developed.
    List<MemoCard> memoCards = _createMemoCards();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Memorization Assistant'),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text('My Cards'),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: memoCards.asMap().entries.map((entry) {
                        int nodeNumber = entry.key;
                        MemoCard memoCard = entry.value;
                        return GestureDetector(
                          onTap: () {
                            context.go(
                              '/${CardDetailsPage.routeName}/$nodeNumber',
                              extra: memoCard,
                            );
                          },
                          child: Row(
                            children: [
                              _buildCard('L$nodeNumber', memoCard),
                              const SizedBox(width: 10),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement navigation to greatwall protocol
                },
                child: const Text('Try protocol'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // TODO Get the memory cards from the derivation protocol.
  List<MemoCard> _createMemoCards() {
    return List.generate(10, (index) {
      MemoCard memoCard = MemoCard();
      memoCard.rateCard(index < 3
          ? "easy"
          : index < 6
              ? "good"
              : "hard");
      if (index == 9) memoCard.rateCard("again");
      return memoCard;
    });
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
          Text(
            title
          ),
          const SizedBox(height: 5),
          Text(
            'Next review:\n${MemoCardUtils.formatDueDate(memoCard.due)}',
        ),
      ],
      ),
    );
  }
}
