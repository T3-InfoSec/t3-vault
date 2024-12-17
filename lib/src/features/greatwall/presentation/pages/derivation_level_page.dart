import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:great_wall/great_wall.dart';
import 'package:t3_vault/src/features/greatwall/presentation/widgets/info_widget.dart';
import '../../../../common/settings/presentation/pages/settings_page.dart';
import '../blocs/blocs.dart';
import '../widgets/hashviz_widget.dart';
import 'derivation_result_page.dart';

class DerivationLevelPage extends StatelessWidget {
  static const routeName = 'derivation_level';

  const DerivationLevelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.derivationLevelPageTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.read<GreatWallBloc>().add(GreatWallReset());
            Navigator.of(context).pop();
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
              return const SizedBox.expand(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: InfoButton(
                          tooltipText:
                              "Argon2, a memory-hard hash, is being computed now. Please wait while derivation happens."
                              "This is a deterministic derivation that imposes a time barrier as a requirement for obtaining the final key. "
                              "Due to technical constraints, even the world's top supercomputers would only perform "
                              "this derivation marginally faster—about 2 to 4 times faster, not a thousandth of the time."
                              "Such a hardly compressible time barrier ensures that a coercive attack is unfeasible. "
                              "Because the derivation is deterministic, the protocol can be hard-reset from any device using only your explicit and tacit memories."),
                    ),
                  ],
                ),
              );
            } else if (state is GreatWallDeriveStepSuccess) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Level ${state.currentLevel} of ${state.treeDepth}:'),
                  if (state.currentLevel == 1)
                    const InfoButton(
                      tooltipText:
                          "At this point, memory-hard derivation is complete. We are now at the root node of the tacit knowledge tree."
                          "A sequence of tacitly memorable choosing steps is required to reach your final key."),
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
                    child: Text(AppLocalizations.of(context)!.previousLevel),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(10),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, // Number of columns in the grid
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1, // Aspect ratio for cells 1:1
                      ),
                      itemCount: state.knowledgePalettes.length,
                      itemBuilder: (context, index) {
                        final TacitKnowledge tacitKnowledge =
                            state.knowledgePalettes[index];
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
                                  );
                                } else {
                                  context
                                      .read<GreatWallBloc>()
                                      .add(GreatWallDerivationFinished());
                                  context.go(
                                    '/${DerivationResultPage.routeName}',
                                  );
                                }
                              },
                            );
                          },
                          child: Builder(builder: (context) {
                            if (tacitKnowledge is FormosaTacitKnowledge) {
                              return Text(tacitKnowledge.knowledge!);
                            } else if (tacitKnowledge
                                is HashVizTacitKnowledge) {
                              return HashvizWidget(
                                imageData: tacitKnowledge.knowledge!,
                                size:
                                    state.tacitKnowledge.configs['hashvizSize'],
                                numColors:
                                    state.tacitKnowledge.configs['numColors'] ??
                                        3,
                                saturation: state
                                        .tacitKnowledge.configs['saturation'] ??
                                    0.7,
                                brightness: state
                                        .tacitKnowledge.configs['brightness'] ??
                                    0.8,
                                minHue:
                                    state.tacitKnowledge.configs['minHue'] ??
                                        90,
                                maxHue:
                                    state.tacitKnowledge.configs['maxHue'] ??
                                        150,
                              );
                            } else {
                              return const Text('Unknown type');
                            }
                          }),
                        );
                      },
                    ),
                  )
                ],
              );
            } else {
              return Center(
                child: Text(AppLocalizations.of(context)!.noLevel),
              );
            }
          },
        ),
      ),
    );
  }
}
