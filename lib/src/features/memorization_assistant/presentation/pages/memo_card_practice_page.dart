import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:great_wall/great_wall.dart';

import 'package:t3_memassist/memory_assistant.dart';
import 'package:t3_vault/src/common/settings/presentation/pages/settings_page.dart';
import 'package:t3_vault/src/features/greatwall/presentation/blocs/blocs.dart';
import 'package:t3_vault/src/features/greatwall/presentation/widgets/hashviz_widget.dart';

class MemoCardPracticePage extends StatelessWidget {
  static const routeName = 'practice';

  final MemoCard memoCard;

  const MemoCardPracticePage({
    super.key,
    required this.memoCard,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.memoCardPracticePageTitle),
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
      body: BlocListener<GreatWallBloc, GreatWallState>(
        listener: (context, state) {
          if (state is GreatWallDeriveStepSuccess) {
            var node = base64Decode(memoCard.knowledge['node']); // TODO: decrypt node value.
            context.read<GreatWallBloc>().add(GreatWallPracticeLevel(node));
          }
        },
        child: Center(
          child: BlocBuilder<GreatWallBloc, GreatWallState>(
            builder: (context, state) {
              if (state is GreatWallPracticeLevelStarted) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Level ${memoCard.knowledge['level']} of ${memoCard.knowledge['treeDepth']}:'),
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
                          final TacitKnowledge tacitKnowledge = state.knowledgePalettes[index];
                          return ElevatedButton(
                            onPressed: () {
                              Future.delayed(
                                const Duration(microseconds: 1),
                                () async {
                                  if (!context.mounted) return;
                                  context.read<GreatWallBloc>().add(
                                      GreatWallPracticeStepMade(index + 1));
                                  // await Future<void>.delayed(
                                  //   const Duration(seconds: 1));
                                  // if (!context.mounted) return;
                                  
                                  var selectedNode = base64Decode(memoCard.knowledge['selectedNode']); // TODO: decrypt selectedNode value.
                                  String resultMessage = "";
                                  if (base64Encode(state.currentHash) == base64Encode(selectedNode)) {
                                    resultMessage = AppLocalizations.of(context)!.correctOption;
                                  } else {
                                    resultMessage = AppLocalizations.of(context)!.incorrectOption;
                                  }
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(resultMessage),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
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
                                  size: memoCard.knowledge['tacitKnowledge'].configs['hashvizSize'],
                                  numColors: memoCard.knowledge['tacitKnowledge'].configs['numColors'] ?? 3,
                                  saturation: memoCard.knowledge['tacitKnowledge'].configs['saturation'] ?? 0.7,
                                  brightness: memoCard.knowledge['tacitKnowledge'].configs['brightness'] ?? 0.8,
                                  minHue: memoCard.knowledge['tacitKnowledge'].configs['minHue'] ?? 90,
                                  maxHue: memoCard.knowledge['tacitKnowledge'].configs['maxHue'] ?? 150,
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
              } else if (state is GreatWallInitialSuccess) {
                context.read<GreatWallBloc>().add(GreatWallDerivationStarted());
                return const CircularProgressIndicator();
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}
