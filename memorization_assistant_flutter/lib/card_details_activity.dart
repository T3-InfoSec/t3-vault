import 'package:flutter/material.dart';

import 'package:memorization_assistant_flutter/utils/memo_card_utils.dart';
import 'package:memory_assistant/memory_assistant.dart';

/// A widget that displays the detailed view of a specific memory card.
///
/// The [CardDetailsActivity] class is a stateless widget that shows the 
/// details of a selected memory card, including its state and due date.
class CardDetailsActivity extends StatelessWidget {
  final int nodeNumber;
  final MemoCard memoCard;

  /// Creates a detailed view of a memory card.
  ///
  /// Constructor requires two parameters: 
  /// [nodeNumber] to identify the position of the card in the knowledge 
  /// tree and [memoCard] to provide the card's data.
  const CardDetailsActivity({
    super.key,
    required this.nodeNumber,
    required this.memoCard,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Greatwall TKBA Protocol'),
        backgroundColor: const Color(0xFF70A8FF),
      ),
      body: Center(
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
                    'Memorization Card L$nodeNumber Details',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'State: ${MemoCardUtils.mapStatusToLabel(memoCard.state)}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    'Due: ${MemoCardUtils.formatDueDate(memoCard.due)}',
                    style: Theme.of(context).textTheme.bodyMedium,
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
    );
  }
}
