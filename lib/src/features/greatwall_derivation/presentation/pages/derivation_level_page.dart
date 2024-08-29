import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/settings/presentation/pages/settings_page.dart';
import '../blocs/greatwall/greatwall_bloc.dart';
import '../blocs/greatwall/greatwall_event.dart';
import '../blocs/greatwall/greatwall_state.dart';
import 'derivation_result_page.dart';

class DerivationLevelPage extends StatelessWidget {
  static const routeName = 'derivation_level';

  const DerivationLevelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GreatWall Derivation Level'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // TODO: _onGoBackToPreviousLevel event
            context.go('/${DerivationLevelPage.routeName}');
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
                            Future.delayed(const Duration(seconds: 1), () {
                              if (!context.mounted) return;
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
                                context
                                    .go("/${DerivationResultPage.routeName}");
                              }
                            });
                          },
                          child: Text(value.knowledge),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  }),
                ],
              );
            } else {
              return const Center(
                  child: Text('Loading or no level data available.'));
            }
          },
        ),
      ),
    );
  }
}
