import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:t3_memassist/memory_assistant.dart';
import 'package:t3_vault/src/common/settings/presentation/pages/settings_page.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/blocs/memo_card_practice/eka/eka_memo_card_practice_bloc.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/blocs/memo_card_practice/eka/eka_memo_card_practice_event.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/blocs/memo_card_practice/eka/eka_memo_card_practice_state.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/pages/memo_card_decks_page.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/pages/memo_card_details_page.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/widgets/feedback_widget.dart';

/// A page for practice eka memory card.
///
/// The [EkaMemoCardPracticePage] class is a stateless widget that displays
/// a question to help the user remember where their eka is stored.
class EkaMemoCardPracticePage extends StatelessWidget {
  static const routeName = 'eka_practice';

  final MemoCard memoCard;

  const EkaMemoCardPracticePage({
    super.key,
    required this.memoCard,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EkaMemoCardPracticeBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!
              .tacitKnowledgeMemoCardPracticePageTitle),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.go(
                '${MemoCardDecksPage.routeName}/${MemoCardDetailsPage.routeName}',
                extra: memoCard,
              );
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
        body: BlocBuilder<EkaMemoCardPracticeBloc, EkaMemoCardPracticeState>(
          builder: (context, state) {
            if (state is EkaMemoCardPracticeFeedback) {
              return FeedbackWidget(memoCard: memoCard, isCorrect: state.isCorrect);
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    memoCard.knowledge['eka'],
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(height: 20),
                _buildButtons(context),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            context.read<EkaMemoCardPracticeBloc>().add(SubmitAnswer(true));
          },
          child: const Text("Yes"),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: () {
            context.read<EkaMemoCardPracticeBloc>().add(SubmitAnswer(false));
          },
          child: const Text("No"),
        ),
      ],
    );
  }
}