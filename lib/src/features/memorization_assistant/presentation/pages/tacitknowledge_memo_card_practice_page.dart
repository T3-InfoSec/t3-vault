import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:great_wall/great_wall.dart';

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
              final TacitKnowledge tacitKnowledge =
                  state.knowledgePalettes[index];
              return ElevatedButton(
                onPressed: () async {
                  Uint8List node = await getNode();
                  if (!context.mounted) return;
                  context.read<GreatWallBloc>().add(
                        GreatWallPracticeStepMade(
                            currentHash: node, choiceNumber: index + 1),
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
      future: getStoredSelectedNode(),
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

  Future<Uint8List> getStoredSelectedNode() async {
    final ephemeralKA = Eka(key: eka);
    Node storedSelectedNode =
        await ephemeralKA.decryptToNode(memoCard.knowledge['selectedNode']);
    return storedSelectedNode.hash;
  }

  Future<Uint8List> getNode() async {
    final ephemeralKA = Eka(key: eka);
    Node storedNode =
        await ephemeralKA.decryptToNode(memoCard.knowledge['node']);
    return storedNode.hash;
  }
}
