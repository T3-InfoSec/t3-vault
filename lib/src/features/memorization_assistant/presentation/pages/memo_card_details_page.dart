import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:t3_memassist/memory_assistant.dart';

import '../../../../core/settings/presentation/pages/settings_page.dart';
import 'memo_cards_page.dart';

/// A page that displays the detailed view of a specific memory card.
///
/// The [CardDetailsPage] class is a stateless widget that shows the
/// details of a selected [memoCard], including its state and due date.
class MemoCardDetailsPage extends StatelessWidget {
  static const routeName = 'memo_card_details';

  final int levelNumber;
  final MemoCard memoCard;

  /// Creates a detailed view of a memory card.
  ///
  /// [levelNumber] identify the position of the card in the knowledge
  /// tree and [memoCard] to provide the card's data.
  const MemoCardDetailsPage({
    super.key,
    required this.levelNumber,
    required this.memoCard,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/${MemoCardsPage.routeName}');
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
                    'Memorization Card L$levelNumber Details',
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'State: ${memoCard.state}',
                  ),
                  Text(
                    'Due: ${memoCard.due}',
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
