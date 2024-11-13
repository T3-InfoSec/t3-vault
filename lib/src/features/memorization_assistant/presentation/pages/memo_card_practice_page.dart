import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:great_wall/great_wall.dart';

import 'package:t3_memassist/memory_assistant.dart';
import 'package:t3_vault/src/common/cryptography/usecases/encryption_service.dart';
import 'package:t3_vault/src/common/settings/presentation/pages/settings_page.dart';
import 'package:t3_vault/src/features/greatwall/presentation/blocs/blocs.dart';
import 'package:t3_vault/src/features/greatwall/presentation/widgets/hashviz_widget.dart';

class MemoCardPracticePage extends StatelessWidget {
  static const routeName = 'practice';

  final encryptionService = EncryptionService();

  final MemoCard memoCard;
  final String eka;

  MemoCardPracticePage({
    super.key,
    required this.memoCard,
    required this.eka,
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
     body: Center(
        child: BlocBuilder<GreatWallBloc, GreatWallState>(
          builder: (context, state) {
            if (state is GreatWallInitialSuccess) {
              context
                .read<GreatWallBloc>()
                .add(GreatWallReset());
                return const CircularProgressIndicator();
            } else if (state is GreatWallInitial) {
              Future.delayed(const Duration(microseconds: 1), () async {
                if (!context.mounted) return;
                Uint8List node = await getNode();
                if (!context.mounted) return;
                context
                    .read<GreatWallBloc>()
                    .add(GreatWallPracticeLevel(node));
              });
              return const CircularProgressIndicator();
            } else if (state is GreatWallPracticeLevelStarted) {
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
                                Uint8List node = await getNode();
                                if (!context.mounted) return;
                                context.read<GreatWallBloc>().add(
                                    GreatWallPracticeStepMade(
                                      currentHash: node,
                                      choiceNumber: index + 1));
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
            } else if (state is GreatWallPracticeLevelFinish) {
              bool isCorrectOption = false;
              Future.delayed(const Duration(microseconds: 1), () async {
                Uint8List storedSelectedNode = await getStoredSelectedNode();
                if (base64Encode(state.selectedNode) ==
                    base64Encode(storedSelectedNode)) {
                  isCorrectOption = true;
                }
              });

              return Center(
                child: Text(
                  isCorrectOption ? "Correct!" : "Incorrect!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isCorrectOption ? Colors.green : Colors.red,
                  ),
                ),
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  Future<Uint8List> getStoredSelectedNode() async {
    Uint8List decodedBytes = base64Decode(memoCard.knowledge['selectedNode']);
    String storedSelectedNode = await encryptionService.decrypt(decodedBytes, eka);
    Uint8List selectedNode = base64Decode(storedSelectedNode);
    return selectedNode;
  }

  Future<Uint8List> getNode() async {
    Uint8List decodedBytes = base64Decode(memoCard.knowledge['node']);
    String storedNode = await encryptionService.decrypt(decodedBytes, eka);
    Uint8List node = base64Decode(storedNode);
    return node;
  }
}
