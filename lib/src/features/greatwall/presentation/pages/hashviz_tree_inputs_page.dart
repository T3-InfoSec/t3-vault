import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:great_wall/great_wall.dart';
import 'package:t3_memassist/memory_assistant.dart';
import 'package:t3_vault/src/features/greatwall/presentation/widgets/pa0_seed_promt_widget.dart';
import 'package:uuid/uuid.dart';

import '../../../../common/settings/presentation/pages/settings_page.dart';
import '../../../memorization_assistant/presentation/blocs/blocs.dart';
import '../blocs/blocs.dart';
import 'confirmation_page.dart';
import 'knowledge_types_page.dart';

class HashvizTreeInputsPage extends StatelessWidget {
  static const routeName = 'hashviz_inputs';

  final TextEditingController _arityController = TextEditingController();
  final TextEditingController _depthController = TextEditingController();
  final TextEditingController _timeLockController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();

  HashvizTreeInputsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hashviz Input Parameters'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.read<MemoCardSetBloc>().add(MemoCardSetUnchanged());
            context.pop();
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _arityController,
              decoration: const InputDecoration(labelText: 'Tree Arity'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _depthController,
              decoration: const InputDecoration(labelText: 'Tree Depth'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _timeLockController,
              decoration:
                  const InputDecoration(labelText: 'Time Lock Puzzle Param'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _sizeController,
              decoration:
                  const InputDecoration(labelText: 'Hashviz block size'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            BlocBuilder<MemoCardSetBloc, MemoCardSetState>(
              builder: (context, memoCardSetState) {
                return ElevatedButton(
                  onPressed: (memoCardSetState is MemoCardSetAddSuccess)
                      ? null
                      : () {
                          final arity = int.parse(_arityController.text);
                          final depth = int.parse(_depthController.text);
                          final timeLock = int.parse(_timeLockController.text);
                          final hashvizSize = int.parse(_sizeController.text);
                          final deck = const Uuid().v4();
                          
                          for (int i = 1; i <= depth; i++) {
                            context.read<MemoCardSetBloc>().add(
                              MemoCardSetCardAdded(
                                memoCard: MemoCard(
                                  knowledge: {
                                    'treeArity': arity,
                                    'treeDepth': i,
                                    'timeLockPuzzleParam': timeLock,
                                    'tacitKnowledge': HashVizTacitKnowledge(
                                      configs: {'hashvizSize': hashvizSize},
                                    ),
                                  },
                                  deck: deck, 
                                ),
                              ),
                            );
                          }
                        },
                  child: const Text('Save To Memorization Card'),
                );
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                String? sixWordsSeed = await showDialog<String>(
                  context: context,
                  builder: (context) => const Pa0SeedPromtWidget(),
                );
                if (sixWordsSeed != null && sixWordsSeed.isNotEmpty) {
                  final arity = int.parse(_arityController.text);
                  final depth = int.parse(_depthController.text);
                  final timeLock = int.parse(_timeLockController.text);
                  final hashvizSize = int.parse(_sizeController.text);

                  Future.delayed(
                    const Duration(seconds: 1),
                    () {
                      if (!context.mounted) return;
                      context.read<GreatWallBloc>().add(
                            GreatWallInitialized(
                              treeArity: arity,
                              treeDepth: depth,
                              timeLockPuzzleParam: timeLock,
                              tacitKnowledge: HashVizTacitKnowledge(
                                configs: {'hashvizSize': hashvizSize},
                              ),
                              secretSeed: sixWordsSeed,
                            ),
                          );
                      context.go(
                        '/${KnowledgeTypesPage.routeName}/$routeName/'
                        '${ConfirmationPage.routeName}',
                      );
                    },
                  );
                }
              },
              child: const Text('Start Derivation'),
            ),
          ],
        ),
      ),
    );
  }
}
