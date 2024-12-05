import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:t3_vault/src/common/settings/presentation/pages/settings_page.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/blocs/memo_card_practice/p0_memo_card_practice_bloc.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/blocs/memo_card_practice/p0_memo_card_practice_event.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/blocs/memo_card_practice/p0_memo_card_practice_state.dart';

/// A page for practice pa0 memory card.
///
/// The [Pa0MemoCardPracticePage] class is a stateless widget that displays
/// pa0 words to help user remember them.
class Pa0MemoCardPracticePage extends StatelessWidget {
  static const routeName = 'pa0_practice';

  final String pa0Seed;

  const Pa0MemoCardPracticePage({
    super.key,
    required this.pa0Seed,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => Pa0MemoCardPracticeBloc(pa0Seed.split(' '))..add(LoadNextWord()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.pa0CardPracticePageTitle),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                context.go('/${SettingsPage.routeName}');
              },
            ),
          ],
        ),
        body: BlocBuilder<Pa0MemoCardPracticeBloc, Pa0MemoCardPracticeState>(
          builder: (context, state) {
            if (state is Pa0PracticeInProgress) {
              return _buildOptions(context, state.options);
            } else if (state is Pa0PracticeFeedback) {
              return _buildFeedback(context, state.isCorrect);
            } else if (state is Pa0PracticeComplete) {
              return const Center(
                child: Text("Practice Complete!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildOptions(BuildContext context, List<String> options) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Select the correct word:",
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 16.0,
          runSpacing: 8.0,
          alignment: WrapAlignment.center,
          children: options.map((word) {
            return ElevatedButton(
              onPressed: () {
                context.read<Pa0MemoCardPracticeBloc>().add(SelectWord(word));
              },
              child: Text(word),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFeedback(BuildContext context, bool isCorrect) {
    return Center(
      child: Text(
        isCorrect ? "Correct!" : "Incorrect!",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: isCorrect ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
