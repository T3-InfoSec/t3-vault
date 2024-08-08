import 'package:flutter/material.dart';

import 'package:t3_vault/src/features/memorization_assistant/presentation/pages/card_details_page.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/utils/memo_card_utils.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/widgets/custom_elevated_button.dart';

import 'package:memory_assistant/memory_assistant.dart';

/// A page for showing memory cards.
///
/// The [MemorizationDeckPage] class is a stateless widget that displays a 
/// collection of memory cards, which users can interact with to review their 
/// tacit knowledge protocol.
class MemorizationDeckPage extends StatelessWidget {
  const MemorizationDeckPage({super.key});

  @override
  Widget build(BuildContext context) {
    // The following variables are harcoded memory cards to be used until the greatwall protocol flow is developed.
    List<MemoCard> memoCards = _createMemoCards();

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
                                  builder: (context) => CardDetailsPage(
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
              CustomElevatedButton(
                text: 'Try protocol',
                onPressed: () {
                  // TODO: Implement navigation to greatwall protocol
                },
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
      memoCard.rateCard(index < 3 ? "easy" : index < 6 ? "good" : "hard");
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
