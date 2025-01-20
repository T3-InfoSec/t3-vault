import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:t3_vault/src/common/notifications/state/notifications_state.dart';
import 'package:t3_vault/src/features/greatwall/presentation/blocs/greatwall/ongoing_derivation/ongoing_derivation_bloc.dart';
import 'package:t3_vault/src/features/greatwall/presentation/blocs/greatwall/ongoing_derivation/ongoing_derivation_event.dart';
import 'package:t3_vault/src/features/greatwall/presentation/blocs/greatwall/ongoing_derivation/ongoing_derivation_state.dart';
import 'package:t3_vault/src/features/greatwall/presentation/widgets/resume_derivation_widget.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/pages/memo_card_decks_page.dart';

import '../../../../common/settings/presentation/pages/settings_page.dart';
import '../../../greatwall/presentation/pages/knowledge_types_page.dart';

/// Displays a list of SampleItems.
class HomePage extends StatelessWidget {
  static const routeName = '/';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationHistory =
        context.watch<NotificationsState>().notificationHistory;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<OngoingDerivationBloc>()
          .add(OngoingDerivationLoadRequested());
    });

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
        child: BlocBuilder<OngoingDerivationBloc, OngoingDerivationState>(
          builder: (context, state) {
            return Column(
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
                        if (state is OngoingDerivationAddSuccess &&
                            state.ongoingDerivationEntity != null) {
                          showDialog(
                            context: context,
                            builder: (context) => ResumeDerivationWidget(
                                ongoingDerivationEntity:
                                    state.ongoingDerivationEntity!),
                          );
                        } else {
                          context.go('/${KnowledgeTypesPage.routeName}');
                        }
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
                        clipBehavior: Clip.none,
                        children: [
                          Text(AppLocalizations.of(context)!.memorizeKeys),
                          if (notificationHistory.isNotEmpty)
                            const Positioned(
                              right: -20,
                              top: -10,
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
            );
          },
        ),
      ),
    );
  }
}
