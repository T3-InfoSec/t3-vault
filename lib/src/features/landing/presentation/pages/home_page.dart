import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:t3_vault/src/common/notifications/state/notifications_state.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/pages/memo_card_decks_page.dart';

import '../../../../common/settings/presentation/pages/settings_page.dart';
import '../../../greatwall/presentation/pages/knowledge_types_page.dart';

/// Displays a list of SampleItems.
class HomePage extends StatelessWidget {
  static const routeName = '/';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final pendingPayload = context.watch<NotificationsState>().pendingPayload;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.homePageTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.go('/${SettingsPage.routeName}');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/flutter_logo.png",
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 30),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.go('/${KnowledgeTypesPage.routeName}');
                  },
                  child: Text(AppLocalizations.of(context)!.deriveKeys),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    context.go(MemoCardDecksPage.routeName);
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(AppLocalizations.of(context)!.memorizeKeys),
                      if (pendingPayload != null)
                        const Positioned(
                          right: 0,
                          top: 0,
                          child: CircleAvatar(
                            radius: 5,
                            backgroundColor: Colors.red,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
