import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:great_wall/great_wall.dart';
import 'package:t3_crypto_objects/crypto_objects.dart';

import 'package:t3_memassist/memory_assistant.dart';
import 'package:t3_vault/src/common/settings/presentation/pages/settings_page.dart';
import 'package:t3_vault/src/features/greatwall/presentation/blocs/blocs.dart';
import 'package:t3_vault/src/features/greatwall/presentation/widgets/hashviz_widget.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/pages/memo_card_decks_page.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/pages/memo_card_details_page.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/widgets/feedback_widget.dart';

/// A page for practicing tacit knowledge memory card.
///
/// The [TacitKnowledgeMemoCardPracticePage] class is a stateless widget that displays
/// derivation options of the given card, which users can interact with to review their
/// tacit knowledge protocol.
class TacitKnowledgeMemoCardPracticePage extends StatelessWidget {
  static const routeName = 'tacit_knowledge_practice';

  final MemoCard memoCard;
  final String eka;

  const TacitKnowledgeMemoCardPracticePage({
    super.key,
    required this.memoCard,
    required this.eka,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!
            .tacitKnowledgeMemoCardPracticePageTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.read<GreatWallBloc>().add(GreatWallReset());
            context.go(
              '${MemoCardDecksPage.routeName}/${MemoCardDetailsPage.routeName}',
              extra: memoCard,
            );
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
              context.read<GreatWallBloc>().add(GreatWallReset());
              return const CircularProgressIndicator();
            } else if (state is GreatWallInitial) {
              Future.delayed(const Duration(microseconds: 1), () async {
                if (!context.mounted) return;
                Uint8List node = await getNode();
                if (!context.mounted) return;
                context.read<GreatWallBloc>().add(GreatWallPracticeLevel(node));
              });
              return const CircularProgressIndicator();
            } else if (state is GreatWallPracticeLevelStarted) {
              if (memoCard.state == CardState.newCard) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _buildCorrectOptionPromt(context, state);
                });
              }
              return _buildPracticeOptions(context, state);
            } else if (state is GreatWallPracticeLevelFinish) {
              return _buildFeedbackSection(context, state);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  void _buildCorrectOptionPromt(
      BuildContext context, GreatWallPracticeLevelStarted state) async {
    Map<Choice, TacitKnowledge> tacitKnowledges = state.knowledgePalettes;
    GreatWall greatwall = state.greatWall;
    Uint8List correctNode = await getNode(isSelectedNode: true);
    Uint8List current = await getNode();

    TacitKnowledge? correctTacitKnowlege;


    if (!context.mounted) return;
    var hashes = context.read<GreatWallBloc>().hashes;
    for (int i = 0; i < state.knowledgePalettes.length; i++) {
      TacitKnowledge tacitKnowledge = tacitKnowledges[Choice(hashes[i + 1])]!;
      Uint8List optionNode = greatwall.getSelectedNode(current, (i + 1).toString());
      if (listEquals(optionNode, correctNode)) {
        correctTacitKnowlege = tacitKnowledge;
      }
    }

    if (!context.mounted) return;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title:
                const Text('This is the correct option. Try to remember it:'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (correctTacitKnowlege != null)
                  _buildOptionContent(correctTacitKnowlege)
                else
                  const Text("No tacit knowledge found")
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(AppLocalizations.of(context)!.ok),
              ),
            ],
          );
        });
  }

  Widget _buildPracticeOptions(
      BuildContext context, GreatWallPracticeLevelStarted state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
            'Level ${memoCard.knowledge['level']} of ${memoCard.knowledge['treeDepth']}:'),
        const SizedBox(height: 10),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, // Number of columns in the grid
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1, // Aspect ratio for cells 1:1
            ),
            itemCount: state.knowledgePalettes.length,
            itemBuilder: (context, index) {
              Choice indexChoice = Choice(context.read<GreatWallBloc>().hashes[index + 1]);
              final TacitKnowledge tacitKnowledge =
                state.knowledgePalettes[indexChoice]!;
              return ElevatedButton(
                onPressed: () async {
                  Uint8List node = await getNode();
                  if (!context.mounted) return;
                  context.read<GreatWallBloc>().add(
                        GreatWallPracticeStepMade(
                            currentHash: node, choice: (index + 1).toString()),
                      );
                },
                child: _buildOptionContent(tacitKnowledge),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOptionContent(TacitKnowledge tacitKnowledge) {
    if (tacitKnowledge is FormosaTacitKnowledge) {
      return Text(tacitKnowledge.knowledge!);
    } else if (tacitKnowledge is HashVizTacitKnowledge) {
      return HashvizWidget(
        imageData: tacitKnowledge.knowledge!,
        size: memoCard.knowledge['tacitKnowledge'].configs['hashvizSize'],
        numColors:
            memoCard.knowledge['tacitKnowledge'].configs['numColors'] ?? 3,
        saturation:
            memoCard.knowledge['tacitKnowledge'].configs['saturation'] ?? 0.7,
        brightness:
            memoCard.knowledge['tacitKnowledge'].configs['brightness'] ?? 0.8,
        minHue: memoCard.knowledge['tacitKnowledge'].configs['minHue'] ?? 90,
        maxHue: memoCard.knowledge['tacitKnowledge'].configs['maxHue'] ?? 150,
      );
    } else {
      return const Text('Unknown type');
    }
  }

  Widget _buildFeedbackSection(
      BuildContext context, GreatWallPracticeLevelFinish state) {
    return FutureBuilder<Uint8List>(
      future: getNode(isSelectedNode: true),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error occurred"));
        } else if (snapshot.hasData) {
          bool isCorrectOption = listEquals(state.selectedNode, snapshot.data);

          return FeedbackWidget(memoCard: memoCard, isCorrect: isCorrectOption);
        }
        return const Center(child: Text("No data found"));
      },
    );
  }

  Future<Uint8List> getNode({bool isSelectedNode = false}) async {
    final ephemeralKA = Eka.fromKey(eka);
    String key = isSelectedNode ? 'selectedNode' : 'node';

    var critical =
        await ephemeralKA.decrypt(base64Decode(memoCard.knowledge[key]));

    int nodeDepth = memoCard.knowledge['level'];

    Node node = Node(critical.value, nodeDepth: nodeDepth);
    return node.value;
  }
}
