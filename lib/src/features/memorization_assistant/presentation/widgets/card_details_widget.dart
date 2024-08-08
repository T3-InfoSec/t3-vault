import 'package:flutter/material.dart';

import 'package:memory_assistant/memory_assistant.dart';

import 'package:t3_vault/src/features/memorization_assistant/presentation/utils/memo_card_utils.dart';

class CardDetailsWidget extends StatelessWidget {
  final int nodeNumber;
  final MemoCard memoCard;

  const CardDetailsWidget({
    super.key,
    required this.nodeNumber,
    required this.memoCard,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
