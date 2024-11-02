import 'package:flutter/material.dart';

class DeckViewerWidget extends StatelessWidget {
  final ThemeData themeData;
  final dynamic name;
  final int cardsNum;

  const DeckViewerWidget({
    super.key,
    required this.themeData,
    required this.name,
    required this.cardsNum,
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
            '$name',
          ),
          const SizedBox(height: 5),
          Text(
            style: TextStyle(
              fontSize: themeData.textTheme.bodySmall!.fontSize,
              fontWeight: themeData.textTheme.bodySmall!.fontWeight,
              color: themeData.colorScheme.onPrimary,
            ),
            '$cardsNum Cards',
          ),
        ],
      ),
    );
  }
}