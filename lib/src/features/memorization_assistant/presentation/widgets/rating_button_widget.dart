import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:t3_memassist/memory_assistant.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/pages/memo_card_decks_page.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/pages/memo_card_details_page.dart';

import '../blocs/blocs.dart';

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
              MemoCardRatingPressed(rating: text, memoCard: memoCard),
            );
        context.go(
          '${MemoCardDecksPage.routeName}/${MemoCardDetailsPage.routeName}',
          extra: memoCard,
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
