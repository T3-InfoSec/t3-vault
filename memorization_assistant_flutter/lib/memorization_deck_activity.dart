import 'package:flutter/material.dart';

import 'package:memorization_assistant_flutter/card_details_activity.dart';
import 'package:memorization_assistant_flutter/utils/memo_card_utils.dart';
import 'package:memory_assistant/memory_assistant.dart';

/// A widget that represents the main activity for showing memory cards 
/// in the Memorization Deck.
///
/// The [MemorizationDeckActivity] class is a stateless widget that displays a 
/// collection of memory cards, which users can interact with to review their 
/// tacit knowledge protocol.
class MemorizationDeckActivity extends StatelessWidget {
  const MemorizationDeckActivity({super.key});

  @override
  Widget build(BuildContext context) {
    // The following variables are harcoded memory cards to be used until the greatwall protocol flow is developed.
    // TODO Gets the memory cards from the protocol.
    MemoCard level1MemoCard = MemoCard();
    level1MemoCard.rateCard("easy");
    MemoCard level2MemoCard = MemoCard();
    level2MemoCard.rateCard("easy");
    MemoCard level3MemoCard = MemoCard();
    level3MemoCard.rateCard("easy");
    MemoCard level4MemoCard = MemoCard();
    level4MemoCard.rateCard("good");
    MemoCard level5MemoCard = MemoCard();
    level5MemoCard.rateCard("good");
    MemoCard level6MemoCard = MemoCard();
    level6MemoCard.rateCard("good");
    MemoCard level7MemoCard = MemoCard();
    level7MemoCard.rateCard("hard");
    MemoCard level8MemoCard = MemoCard();
    level8MemoCard.rateCard("hard");
    MemoCard level9MemoCard = MemoCard();
    level9MemoCard.rateCard("hard");
    MemoCard level10MemoCard = MemoCard();
    level10MemoCard.rateCard("again");

    List<MemoCard> memoCards = [
      level1MemoCard,
      level2MemoCard,
      level3MemoCard,
      level4MemoCard,
      level5MemoCard,
      level6MemoCard,
      level7MemoCard,
      level8MemoCard,
      level9MemoCard,
      level10MemoCard
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Greatwall TKBA Protocol'),
        backgroundColor: const Color(0xFF70A8FF),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'My Cards',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: memoCards.asMap().entries.map((entry) {
                          int nodeNumber = entry.key;
                          MemoCard memoCard = entry.value;
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CardDetailsActivity(
                                      nodeNumber: nodeNumber,
                                      memoCard: memoCard),
                                ),
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
              ),
              const SizedBox(height: 60),
              SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF70A8FF),
                  ),
                  onPressed: () {
                    // TODO go to greatwall protocol
                  },
                  child: const Text('Try protocol'),
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 5),
          Text(
            'Next review:\n${MemoCardUtils.formatDueDate(memoCard.due)}',
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
