import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3_memassist/memory_assistant.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/blocs/blocs.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/widgets/widgets.dart';

class FeedbackWidget extends StatelessWidget {
  final MemoCard memoCard;
  final bool isCorrect;

  const FeedbackWidget({
    super.key,
    required this.memoCard,
    required this.isCorrect,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!isCorrect)
            Text(
              'Incorrect',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isCorrect ? Colors.green : Colors.red,
              ),
            )
          else
            Text(
              'Correct',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isCorrect ? Colors.green : Colors.red,
              ),
            ),
          const SizedBox(height: 20),
          BlocBuilder<MemoCardRatingBloc, MemoCardRatingState>(
            builder: (context, state) {
              return Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                alignment: WrapAlignment.center,
                children: [
                  RatingButton(
                    memoCard: memoCard,
                    themeData: themeData,
                    text: 'Again',
                  ),
                  RatingButton(
                    memoCard: memoCard,
                    themeData: themeData,
                    text: 'Hard',
                  ),
                  RatingButton(
                    memoCard: memoCard,
                    themeData: themeData,
                    text: 'Good',
                  ),
                  RatingButton(
                    memoCard: memoCard,
                    themeData: themeData,
                    text: 'Easy',
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
