import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:great_wall/great_wall.dart';
import 'package:t3_formosa/formosa.dart';
import 'package:t3_memassist/memory_assistant.dart';
import 'package:t3_vault/src/features/greatwall/presentation/widgets/pa0_seed_promt_widget.dart';

import '../../../../common/settings/presentation/pages/settings_page.dart';
import '../../../memorization_assistant/presentation/blocs/blocs.dart';
import '../blocs/blocs.dart';
import 'confirmation_page.dart';
import 'knowledge_types_page.dart';

class FormosaTreeInputsPage extends StatelessWidget {
  static const routeName = 'formosa_inputs';

  final TextEditingController _arityController = TextEditingController();
  final TextEditingController _depthController = TextEditingController();
  final TextEditingController _timeLockController = TextEditingController();

  FormosaTreeInputsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formosa Input Parameters'),
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
            BlocBuilder<FormosaBloc, FormosaState>(
              builder: (context, state) {
                FormosaTheme? selectedTheme;

                if (state is FormosaThemeSelectSuccess) {
                  selectedTheme = state.theme;
                }

                return DropdownButton<FormosaTheme>(
                  value: selectedTheme,
                  hint: const Text('Select Theme'),
                  items: FormosaTheme.values.map((FormosaTheme theme) {
                    return DropdownMenuItem<FormosaTheme>(
                      value: theme,
                      child: Text(theme.name),
                    );
                  }).toList(),
                  onChanged: (selectedTheme) {
                    if (selectedTheme != null) {
                      context
                          .read<FormosaBloc>()
                          .add(FormosaThemeSelected(theme: selectedTheme));
                    }
                  },
                );
              },
            ),
            const SizedBox(height: 10),
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
            BlocBuilder<MemoCardSetBloc, MemoCardSetState>(
              builder: (context, memoCardSetState) {
                return ElevatedButton(
                  onPressed: (memoCardSetState is MemoCardSetAddSuccess)
                      ? null
                      : () {
                          final arity = int.parse(_arityController.text);
                          final depth = int.parse(_depthController.text);
                          final timeLock = int.parse(_timeLockController.text);
                          final theme = (context.read<FormosaBloc>().state
                                  as FormosaThemeSelectSuccess)
                              .theme;

                          context.read<MemoCardSetBloc>().add(
                                MemoCardSetCardAdded(
                                  memoCard: MemoCard(
                                    knowledge: {
                                      'treeArity': arity,
                                      'treeDepth': depth,
                                      'timeLockPuzzleParam': timeLock,
                                      'tacitKnowledge': FormosaTacitKnowledge(
                                        configs: {'formosaTheme': theme},
                                      ),
                                    },
                                  ),
                                ),
                              );
                        },
                  child: const Text('Save To Memorization Card'),
                );
              },
            ),
            const SizedBox(height: 10),
            BlocBuilder<GreatWallBloc, GreatWallState>(
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: () async {
                    String? sixWordsSeed = await showDialog<String>(
                      context: context,
                      builder: (context) => const Pa0SeedPromtWidget(),
                    );
                    if (sixWordsSeed != null && sixWordsSeed.isNotEmpty) {
                      if (!context.mounted) return;
                      final arity = int.parse(_arityController.text);
                      final depth = int.parse(_depthController.text);
                      final timeLock = int.parse(_timeLockController.text);
                      final theme = (context.read<FormosaBloc>().state
                              as FormosaThemeSelectSuccess)
                          .theme;

                      Future.delayed(
                        const Duration(seconds: 1),
                        () {
                          if (!context.mounted) return;
                          context.read<GreatWallBloc>().add(
                                GreatWallInitialized(
                                  treeArity: arity,
                                  treeDepth: depth,
                                  timeLockPuzzleParam: timeLock,
                                  tacitKnowledge: FormosaTacitKnowledge(
                                    configs: {'formosaTheme': theme},
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
