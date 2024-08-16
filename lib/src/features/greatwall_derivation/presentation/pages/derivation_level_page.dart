import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:t3_vault/src/features/greatwall_derivation/presentation/bloc/greatwall/greatwall_bloc.dart';
import 'package:t3_vault/src/features/greatwall_derivation/presentation/bloc/greatwall/greatwall_event.dart';
import 'package:t3_vault/src/features/greatwall_derivation/presentation/bloc/greatwall/greatwall_state.dart';

import 'package:t3_vault/src/features/greatwall_derivation/presentation/pages/derivation_result_page.dart';
import 'package:t3_vault/src/features/greatwall_derivation/presentation/pages/tree_inputs_page.dart';
import 'package:t3_vault/src/core/settings/presentation/pages/settings_page.dart';

class DerivationLevelPage extends StatelessWidget {
  const DerivationLevelPage({super.key});

  static const routeName = 'derivation_level';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GreatWallBloc()..add(LoadArityIndexes()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('T3-Vault'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.go('/${TreeInputsPage.routeName}'); // TODO: re-initialize the protocol derivation process.
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
                    ...state.arityIndexes.map((index) {
                      return Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              context.read<GreatWallBloc>().add(MakeTacitDerivation(int.parse(index)));
                              if (state.currentLevel < state.treeDepth) {
                                context.read<GreatWallBloc>().add(AdvanceToNextLevel());
                                context.go(DerivationLevelPage.routeName);
                              } else {
                                context.read<GreatWallBloc>().add(FinishDerivation());
                                context.go(DerivationResultPage.routeName);
                              }
                            },
                            child: Text(index),
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    }),
                  ],
                );
              } else {
                print(state.toString());
                return const Center(child: Text('Loading or no data available.'));
              }
            },
          ),
        ),
      ),
    );
  }
}
