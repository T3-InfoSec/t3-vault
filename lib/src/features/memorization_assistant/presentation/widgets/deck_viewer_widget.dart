import 'package:flutter/material.dart';

class DeckViewerWidget extends StatelessWidget {
  final ThemeData themeData;
  final dynamic name;
  final int cardsNum;
  final bool toBeReviewed;

  const DeckViewerWidget({
    super.key,
    required this.themeData,
    required this.name,
    required this.cardsNum,
    this.toBeReviewed = false,
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
                '$name',
                style: TextStyle(
                  fontSize: themeData.textTheme.titleLarge!.fontSize,
                  fontWeight: themeData.textTheme.titleLarge!.fontWeight,
                  color: themeData.colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '$cardsNum Cards',
                style: TextStyle(
                  fontSize: themeData.textTheme.bodySmall!.fontSize,
                  fontWeight: themeData.textTheme.bodySmall!.fontWeight,
                  color: themeData.colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
        if (toBeReviewed)
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
