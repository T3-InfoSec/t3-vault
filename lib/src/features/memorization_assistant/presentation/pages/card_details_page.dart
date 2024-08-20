import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:memory_assistant/memory_assistant.dart';

import 'package:t3_vault/src/core/settings/presentation/pages/settings_page.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/pages/memorization_assistant_deck_page.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/utils/memo_card_utils.dart';

/// A page that displays the detailed view of a specific memory card.
///
/// The [CardDetailsPage] class is a stateless widget that shows the
/// details of a selected [memoCard], including its state and due date.
class CardDetailsPage extends StatelessWidget {
  static const routeName = 'card_details';

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
      appBar: AppBar(
        title: const Text('Memorization Card Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go(MemorizationDeckPage.routeName);
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFF4A6FA5),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Memorization Card L$nodeNumber Details',
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'State: ${MemoCardUtils.mapStatusToLabel(memoCard.state)}',
                  ),
                  Text(
                    'Due: ${MemoCardUtils.formatDueDate(memoCard.due)}',
                  ),
                ],
              ),
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
    );
  }
}
