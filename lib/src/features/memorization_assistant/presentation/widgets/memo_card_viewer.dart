import 'package:flutter/material.dart';
import 'package:t3_memassist/memory_assistant.dart';

class MemoCardViewer extends StatelessWidget {
  final ThemeData themeData;
  final int levelNumber;
  final MemoCard memoCard;

  const MemoCardViewer({
    super.key,
    required this.themeData,
    required this.levelNumber,
    required this.memoCard,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 150,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: themeData.colorScheme.primary,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            style: TextStyle(
              fontSize: themeData.textTheme.titleLarge!.fontSize,
              fontWeight: themeData.textTheme.titleLarge!.fontWeight,
              color: themeData.colorScheme.onPrimary,
            ),
            'L$levelNumber',
          ),
          const SizedBox(height: 5),
          Text(
            style: TextStyle(
              fontSize: themeData.textTheme.bodySmall!.fontSize,
              fontWeight: themeData.textTheme.bodySmall!.fontWeight,
              color: themeData.colorScheme.onPrimary,
            ),
            'Next review:\n${memoCard.due.toLocal()}',
          ),
        ],
      ),
    );
  }
}
