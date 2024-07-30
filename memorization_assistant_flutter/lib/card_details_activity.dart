import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memory_assistant/memory_assistant.dart';

class CardDetailsActivity extends StatelessWidget {
  final int nodeNumber;
  final MemoCard memoCard;

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
                    'State: ${memoCard.state}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    'Due: ${_formatDueDate(memoCard.due)}',
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
                  // TODO Redirect to greatwall protocol
                },
                child: const Text('Try protocol'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDueDate(DateTime? dueDate) {
    if (dueDate == null) return 'Not scheduled';
    return DateFormat('yyyy-MM-dd HH:mm').format(dueDate.toLocal());
  }
}
