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
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(10),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // Number of columns in the grid
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1, // Aspect ratio for cells 1:1
                      ),
                      itemCount: state.knowledgePalettes.length,
                      itemBuilder: (context, index) {
                        final value = state.knowledgePalettes[index];
                        return ElevatedButton(
                          onPressed: () {
                            Future.delayed(
                              const Duration(seconds: 1),
                              () {
                                if (!context.mounted) return;
                                context.read<GreatWallBloc>().add(
                                    GreatWallDerivationStepMade(index + 1));
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
                        );
                      },
                    ),
                  )
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
  Widget renderKnowledgeWidget(value, dynamic tacitKnowledgeConfigs) {
    if (value.knowledge is String) {
      return Text(value.knowledge);
    } else if (value.knowledge is List<int>) {
      List<int> imageData = value.knowledge as List<int>;
      return SizedBox(
        width: 256,
        height: 256,
        child: CustomPaint(
          painter: HashvizPainter(
            imageData: imageData,
            size: tacitKnowledgeConfigs['size'] ?? 16,
            numColors: tacitKnowledgeConfigs['numColors'] ?? 3,
            saturation: tacitKnowledgeConfigs['saturation'] ?? 0.7,
            brightness: tacitKnowledgeConfigs['brightness'] ?? 0.8,
            minHue: tacitKnowledgeConfigs['minHue'] ?? 90,
            maxHue: tacitKnowledgeConfigs['maxHue'] ?? 150,
          ),
        ),
      );
    } else {
      return const Text('Unknown type');
    }
  }
}
