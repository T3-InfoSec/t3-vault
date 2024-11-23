import 'package:flutter/material.dart';
import 'package:t3_memassist/memory_assistant.dart';

class MemoCardViewer extends StatelessWidget {
  final ThemeData themeData;
  final MemoCard memoCard;
  final bool isToBeReviewed;

  const MemoCardViewer({
    super.key,
    required this.themeData,
    required this.memoCard,
    required this.isToBeReviewed
  });

  @override
  Widget build(BuildContext context) {

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
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
                memoCard.title,
                style: TextStyle(
                  fontSize: themeData.textTheme.titleLarge!.fontSize,
                  fontWeight: themeData.textTheme.titleLarge!.fontWeight,
                  color: themeData.colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Next review:\n${memoCard.due.toLocal()}',
                style: TextStyle(
                  fontSize: themeData.textTheme.bodySmall!.fontSize,
                  fontWeight: themeData.textTheme.bodySmall!.fontWeight,
                  color: themeData.colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
        if (isToBeReviewed)
          Positioned(
            top: -5,
            right: -5,
            child: Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}
