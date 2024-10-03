import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:t3_memassist/memory_assistant.dart';

import '../../../../common/settings/presentation/pages/settings_page.dart';
import '../blocs/blocs.dart';
import '../widgets/widgets.dart';
import 'memo_card_details_page.dart';

/// A page for showing memory cards.
///
/// The [MemoCardsPage] class is a stateless widget that displays a
/// collection of memory cards, which users can interact with to review their
/// tacit knowledge protocol.
class MemoCardsPage extends StatelessWidget {
  static const routeName = 'memo_cards';

  const MemoCardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Memorization Cards'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.go('/${SettingsPage.routeName}');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<MemoCardSetBloc, MemoCardSetState>(
              builder: (context, memoCardSetState) {
                if (memoCardSetState.memoCardSet.isEmpty) {
                  return const Text('No Memorization Card Yet!');
                }
                return BlocBuilder<MemoCardRatingBloc, MemoCardRatingState>(
                  builder: (context, ratingState) {
                    return Wrap(
                      spacing: 5.0,
                      runSpacing: 5.0,
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children:
                          memoCardSetState.memoCardSet.asMap().entries.map(
                        (entry) {
                          int levelNumber = entry.key;
                          MemoCard memoCard = entry.value;
                          return GestureDetector(
                            onTap: () {
                              context.go(
                                '/$routeName/${MemoCardDetailsPage.routeName}'
                                '/$levelNumber',
                                extra: memoCard,
                              );
                            },
                            child: MemoCardViewer(
                              themeData: themeData,
                              levelNumber: levelNumber,
                              memoCard: memoCard,
                            ),
                          );
                        },
                      ).toList(),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
