import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:t3_memassist/memory_assistant.dart';

import 'package:t3_vault/src/common/settings/presentation/pages/settings_page.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/blocs/memo_card_practice/sa0/sa0_memo_card_practice_bloc.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/blocs/memo_card_practice/sa0/sa0_memo_card_practice_event.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/blocs/memo_card_practice/sa0/sa0_memo_card_practice_state.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/pages/memo_card_decks_page.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/pages/memo_card_details_page.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/widgets/feedback_widget.dart';

class Sa0MemoCardPracticePage extends StatelessWidget {
  static const routeName = 'sa0_practice';

  final MemoCard memoCard;
  final String sa0Mnemonic;

  const Sa0MemoCardPracticePage({
    super.key,
    required this.memoCard,
    required this.sa0Mnemonic,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => Sa0MemoCardPracticeBloc(sa0Mnemonic),
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
        body: BlocBuilder<Sa0MemoCardPracticeBloc, Sa0MemoCardPracticeState>(
          builder: (context, state) {
            if (state is Sa0PracticeInProgress) {
              if (memoCard.state == CardState.newCard) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _buildcorrectOptionPromt(context, sa0Mnemonic);
                });
              }
              return _buildInputForm(context);
            } else if (state is Sa0PracticeFeedback) {
              return FeedbackWidget(
                  memoCard: memoCard, isCorrect: state.isCorrect);
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  void _buildcorrectOptionPromt(BuildContext context, String sa0Mnemonic) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('This is the correct option. Try to remember it:'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  sa0Mnemonic,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(AppLocalizations.of(context)!.ok),
              ),
            ],
          );
        });
  }

  Widget _buildInputForm(BuildContext context) {
    final controller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Enter the words (space-separated):",
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Enter the words here",
            ),
            onSubmitted: (input) {
              context.read<Sa0MemoCardPracticeBloc>().add(SubmitWords(input));
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              context
                  .read<Sa0MemoCardPracticeBloc>()
                  .add(SubmitWords(controller.text));
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }
}
