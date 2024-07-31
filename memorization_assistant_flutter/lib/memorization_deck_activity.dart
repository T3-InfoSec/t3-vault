import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:memorization_assistant_flutter/card_details_activity.dart';
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
    Map<String, dynamic> knowledgeTree = {
      "firstLevel": [
        "48c52a27aed9c85e69925c4132d71dabfbb4f89500931fbdc62393f8d87a41d0",
        "e4194aaba55b31863701448601059117380743180332343aa31f28036177380a"
      ],
      "secondLevel": {
        "option1": [
          "3af2c496544250ce6e5d81718a71d7444da8354c22e1a532f1e2716796d4dfd1",
          "6cb26a11ea79cb18e9a468f9950050fefc9d3303d918dbcef1f9cb1180024c70"
        ],
        "option2": [
          "a37f389f59d9aeebe792e69c274386be7b627f689a96e804f10b22d98caa2ef1",
          "5c10776f6eaa9fae4e77b136fe2b6ed4de3e7a3dcee0f26fd1c737c390a72693"
        ],
      }
    };

    MemoCard level1MemoCard = MemoCard(knowledgeTree);
    MemoCard level2MemoCard = MemoCard(knowledgeTree);
    MemoCard level3MemoCard = MemoCard(knowledgeTree);
    MemoCard level4MemoCard = MemoCard(knowledgeTree);
    MemoCard level5MemoCard = MemoCard(knowledgeTree);
    MemoCard level6MemoCard = MemoCard(knowledgeTree);
    MemoCard level7MemoCard = MemoCard(knowledgeTree);
    MemoCard level8MemoCard = MemoCard(knowledgeTree);
    MemoCard level9MemoCard = MemoCard(knowledgeTree);
    MemoCard level10MemoCard = MemoCard(knowledgeTree);

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
                  onPressed: () {},
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
            'Next review:\n${_formatDueDate(memoCard.due)}',
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }

  String _formatDueDate(DateTime? dueDate) {
    if (dueDate == null) return 'Not scheduled';

    return DateFormat('yyyy-MM-dd HH:mm').format(dueDate.toLocal());
  }
}
