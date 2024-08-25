import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3_memassist/memory_assistant.dart';

import '../bloc/blocs.dart';

class RatingButton extends StatelessWidget {
  final MemoCard memoCard;

  final ThemeData themeData;
  final String text;
  const RatingButton({
    super.key,
    required this.memoCard,
    required this.themeData,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll<Color>(
          switch (text) {
            'Again' => Colors.grey,
            'Hard' => Colors.red,
            'Good' => Colors.green,
            'Easy' => Colors.lightGreen,
            _ => Colors.grey,
          },
        ),
      ),
      onPressed: () {
        memoCard.rateCard(text.toLowerCase());
        context.read<MemoCardRatingBloc>().add(
              MemoCardRatingPressed(rating: text),
            );
      },
      child: Text(
        style: TextStyle(
          color: themeData.colorScheme.onPrimary,
        ),
        text,
      ),
    );
  }
}
