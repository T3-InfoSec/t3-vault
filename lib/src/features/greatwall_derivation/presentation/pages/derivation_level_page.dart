import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:t3_vault/src/features/greatwall_derivation/presentation/bloc/greatwall/greatwall_bloc.dart';
import 'package:t3_vault/src/features/greatwall_derivation/presentation/bloc/greatwall/greatwall_event.dart';
import 'package:t3_vault/src/features/greatwall_derivation/presentation/bloc/greatwall/greatwall_state.dart';

import 'package:t3_vault/src/features/greatwall_derivation/presentation/pages/derivation_result_page.dart';
import 'package:t3_vault/src/core/settings/presentation/pages/settings_page.dart';

class DerivationLevelPage extends StatelessWidget {
  const DerivationLevelPage({super.key});

  static const routeName = 'derivation_level';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GreatWall Derivation Level'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go(
                '/${DerivationLevelPage.routeName}'); // TODO: _onGoBackToPreviousLevel event
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
      body: Center(
        child: BlocBuilder<GreatWallBloc, GreatWallState>(
          builder: (context, state) {
            if (state is GreatWallLoadedArityIndexes) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Level ${state.currentLevel} of ${state.treeDepth}:'),
                  const SizedBox(height: 10),
                  ...state.knowledgeValues.asMap().entries.map((entry) {
                    int index = entry.key;
                    dynamic value = entry.value;
                    return Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            context
                                .read<GreatWallBloc>()
                                .add(MakeTacitDerivation(index));
                            if (state.currentLevel < state.treeDepth) {
                              context
                                  .read<GreatWallBloc>()
                                  .add(AdvanceToNextLevel());
                              context.go("/${DerivationLevelPage.routeName}");
                            } else {
                              context
                                  .read<GreatWallBloc>()
                                  .add(FinishDerivation());
                              context.go("/${DerivationResultPage.routeName}");
                            }
                          },
                          child: Text(value),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  }),
                ],
              );
            } else {
              return const Center(child: Text('Loading or no level data available.'));
            }
          },
        ),
      ),
    );
  }
}
