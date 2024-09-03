import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/settings/presentation/pages/settings_page.dart';
import '../blocs/blocs.dart';
import 'derivation_result_page.dart';
import 'formosa_tree_inputs_page.dart';

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
            context.go('/${FormosaTreeInputsPage.routeName}'); // TODO: fix navigation
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
            if (state is GreatWallDeriveInProgress) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is GreatWallDeriveStepSuccess) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Level ${state.currentLevel} of ${state.treeDepth}:'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (state.currentLevel > 1) {
                        context
                            .read<GreatWallBloc>()
                            .add(GreatWallDerivationStepMade(0));
                        context.go('/${DerivationLevelPage.routeName}');
                      }
                    },
                    child: const Text('Previous Level'),
                  ),
                  const SizedBox(height: 10),
                  ...state.knowledgePalettes.asMap().entries.map(
                    (entry) {
                      int index = entry.key + 1;
                      dynamic value = entry.value;

                      return Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Future.delayed(
                                const Duration(seconds: 1),
                                () {
                                  if (!context.mounted) return;
                                  context
                                      .read<GreatWallBloc>()
                                      .add(GreatWallDerivationStepMade(index));
                                  if (state.currentLevel < state.treeDepth) {
                                    context.go(
                                        '/${DerivationLevelPage.routeName}');
                                  } else {
                                    context
                                        .read<GreatWallBloc>()
                                        .add(GreatWallDerivationFinished());
                                    context.go(
                                        '/${DerivationResultPage.routeName}');
                                  }
                                },
                              );
                            },
                            child: renderKnowledgeWidget(value),
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text('Saved Derived States:'),
                  ...state.savedDerivedStates.entries.map((entry) {
                    return Text('Path: ${entry.key}, Value: ${entry.value}');
                  }),
                ],
              );
            } else {
              return const Center(
                child: Text('Loading or no level data available.'),
              );
            }
          },
        ),
      ),
    );
  }

  Widget renderKnowledgeWidget(value) {
    if (value.knowledge is String) {
      return Text(value.knowledge);
    } else if (value.knowledge is Widget) {
      return value.knowledge as Widget;
    } else {
      return const Text('Unknown type');
    }
  }
}
