import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:t3_memassist/memory_assistant.dart';
import 'package:t3_vault/src/common/notifications/state/notifications_state.dart';

import 'package:t3_vault/src/features/memorization_assistant/presentation/pages/memo_card_decks_page.dart';
import '../../../../common/settings/presentation/pages/settings_page.dart';
import '../widgets/widgets.dart';
import 'memo_card_details_page.dart';

/// A page for showing memory cards.
///
/// The [MemoCardsPage] class is a stateless widget that displays a
/// collection of memory cards, which users can interact with to review their
/// tacit knowledge protocol.
class MemoCardsPage extends StatelessWidget {
  static const routeName = 'cards';

  final List<MemoCard> memoCards;

  /// Creates all memo cards of a deck view.
  ///
  /// [memoCards] all cards from a deck
  const MemoCardsPage({
    super.key, 
    required this.memoCards
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.memoCardsPageTitle),
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
            child: memoCards.isEmpty 
            ? Text(AppLocalizations.of(context)!.noMemoCardsDeck)
            : Wrap(
                spacing: 5.0,
                runSpacing: 5.0,
                direction: Axis.horizontal,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: memoCards.asMap().entries.map(
                  (entry) {
                    MemoCard memoCard = entry.value;
                    return GestureDetector(
                      onTap: () {
                        context.read<NotificationsState>().clearPendingPayload();
                        context.go(
                          '${MemoCardDecksPage.routeName}/${MemoCardDetailsPage.routeName}',
                          extra: memoCard,
                        );
                      },
                      child: MemoCardViewer(
                        themeData: themeData,
                        memoCard: memoCard,
                      ),
                    );
                  },
                ).toList(),
              ),
          ),
        ),
      ),
    );
  }
}