import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../common/settings/presentation/pages/settings_page.dart';
import '../blocs/blocs.dart';
import 'derivation_level_page.dart';

class ConfirmationPage extends StatelessWidget {
  static const routeName = 'confirmation';

  const ConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.confirmationPageTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.go('/${SettingsPage.routeName}');
            },
          ),
        ],
      ),
      body: BlocBuilder<GreatWallBloc, GreatWallState>(
        builder: (context, state) {
          if (state is GreatWallDeriveInProgress) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is GreatWallInitialSuccess) {
            return SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.tacitKnowledge,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(state.tacitKnowledge.toString()),
                    const SizedBox(height: 20),
                    Text(
                      AppLocalizations.of(context)!.treeArity,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('${state.treeArity}'),
                    const SizedBox(height: 20),
                    Text(
                      AppLocalizations.of(context)!.treeDepth,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('${state.treeDepth}'),
                    const SizedBox(height: 20),
                    ...state.tacitKnowledge.configs.entries.map((entry) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            entry.key,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('${entry.value}'),
                          const SizedBox(height: 20),
                        ],
                      );
                    }),
                    Text(
                      AppLocalizations.of(context)!.password,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text('****'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Future.delayed(
                          const Duration(seconds: 1),
                          () {
                            if (!context.mounted) return;
                            context
                                .read<GreatWallBloc>()
                                .add(GreatWallDerivationStarted());
                            context.go('/${DerivationLevelPage.routeName}');
                          },
                        );
                      },
                      child: Text(AppLocalizations.of(context)!.confirm),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: Text(AppLocalizations.of(context)!.noParameters));
          }
        },
      ),
    );
  }
}
