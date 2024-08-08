import 'package:flutter/material.dart';

import 'package:memory_assistant/memory_assistant.dart';

import 'package:t3_vault/src/features/memorization_assistant/presentation/widgets/card_details_widget.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/widgets/custom_elevated_button.dart';

/// A page that displays the detailed view of a specific memory card.
///
/// The [CardDetailsPage] class is a stateless widget that shows the 
/// details of a selected [memoCard], including its state and due date.
class CardDetailsPage extends StatelessWidget {
  final int nodeNumber;
  final MemoCard memoCard;

  /// Creates a detailed view of a memory card.
  ///
  /// Constructor requires two parameters: 
  /// [nodeNumber] to identify the position of the card in the knowledge 
  /// tree and [memoCard] to provide the card's data.
  const CardDetailsPage({
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
            CardDetailsWidget(nodeNumber: nodeNumber, memoCard: memoCard),
            const SizedBox(height: 60),
            CustomElevatedButton(
              text: 'Try protocol',
              onPressed: () {
                // TODO: Implement navigation to Greatwall protocol
              },
            ),
          ],
        ),
      ),
    );
  }
}
