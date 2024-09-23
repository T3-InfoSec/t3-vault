import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:t3_vault/src/features/greatwall/presentation/widgets/hashviz_painter.dart';

import '../../../../common/settings/presentation/pages/settings_page.dart';
import '../blocs/blocs.dart';
import 'derivation_result_page.dart';

class DerivationLevelPage extends StatelessWidget {
  static const routeName = 'derivation_level';

  const DerivationLevelPage({super.key});

  @override
  Widget build(BuildContext context) {
    final previousRoute = (GoRouterState.of(context).extra
        as Map<String, String>)['previousRoute'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('GreatWall Derivation Level'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (previousRoute != null) {
              context.go('/$previousRoute');
            } else {
              Navigator.of(context).pop();
            }
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
                        context.go(
                          '/${DerivationLevelPage.routeName}',
                          extra: {'previousRoute': previousRoute!},
                        );
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
                                      '/${DerivationLevelPage.routeName}',
                                      extra: {'previousRoute': previousRoute!},
                                    );
                                  } else {
                                    context
                                        .read<GreatWallBloc>()
                                        .add(GreatWallDerivationFinished());
                                    context.go(
                                      '/${DerivationResultPage.routeName}',
                                      extra: {'previousRoute': previousRoute!},
                                    );
                                  }
                                },
                              );
                            },
                            child: renderKnowledgeWidget(
                                value, state.tacitKnowledgeConfigs),
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    },
                  ),
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

  /// Renders a widget based on the type of [value.knowledge].
  ///
  /// - Parameters:
  ///   - [value] An object containing the `knowledge` to be rendered.
  ///   - [tacitKnowledgeConfigs] A dynamic configuration map used to determine the pattern grid size.
  ///
  /// - Returns: A [Widget] that represents the rendered knowledge based on the provided value.
  Widget renderKnowledgeWidget(value, dynamic tacitKnowledgeConfigs) { // TODO: Extract to KnowledgeWidget? 
    if (value.knowledge is String) {
      return Text(value.knowledge);
    } else if (value.knowledge is List<int>) {
      List<int> imageData = value.knowledge as List<int>;
      return SizedBox(
        width: 64,
        height: 64,
        child: CustomPaint(
          painter: HashvizPainter(
            imageData: imageData,
            size: tacitKnowledgeConfigs['size'] ?? 16,
          ),
        ),
      );
    } else {
      return const Text('Unknown type');
    }
  }
}
