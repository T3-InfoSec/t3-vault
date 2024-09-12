import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:great_wall/great_wall.dart';
import 'package:t3_memassist/memory_assistant.dart';

import '../../../../common/settings/presentation/pages/settings_page.dart';
import '../../../memorization_assistant/presentation/blocs/blocs.dart';
import '../blocs/blocs.dart';
import 'confirmation_page.dart';
import 'knowledge_types_page.dart';

class HashvizTreeInputsPage extends StatelessWidget {
  static const routeName = 'hashviz_tree_inputs';

  final TextEditingController _arityController = TextEditingController();
  final TextEditingController _depthController = TextEditingController();
  final TextEditingController _timeLockController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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
            context.go('/${KnowledgeTypesPage.routeName}');
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
          if (state is GreatWallInputInvalid) {
            final errors = state.errors;
            final errorMessage = errors.values.join('\n');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(errorMessage)),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: _arityController,
                decoration: const InputDecoration(labelText: 'Tree Arity'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  context.read<GreatWallBloc>().add(
                        GreatWallArityChanged(_arityController.text),
                      );
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _depthController,
                decoration: const InputDecoration(labelText: 'Tree Depth'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  context.read<GreatWallBloc>().add(
                        GreatWallDepthChanged(_depthController.text),
                      );
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _timeLockController,
                decoration:
                    const InputDecoration(labelText: 'Time Lock Puzzle Param'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  context.read<GreatWallBloc>().add(
                        GreatWallTimeLockChanged(_timeLockController.text),
                      );
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _sizeController,
                decoration:
                    const InputDecoration(labelText: 'Hashviz block size'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              BlocBuilder<GreatWallBloc, GreatWallState>(
                builder: (context, state) {
                  bool isPasswordVisible = false;

                  if (state is GreatWallPasswordVisibility) {
                    isPasswordVisible = state.isPasswordVisible;
                  }

                  return TextField(
                    controller: _passwordController,
                    obscureText: !isPasswordVisible,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          context
                              .read<GreatWallBloc>()
                              .add(GreatWallPasswordVisibilityToggled());
                        },
                      ),
                    ),
                  );
                },
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
                            final timeLock =
                                int.parse(_timeLockController.text);
                            final size = int.parse(_sizeController.text);

                            context.read<MemoCardSetBloc>().add(
                                  MemoCardSetCardAdded(
                                    memoCard: MemoCard(
                                      knowledge: {
                                        'treeArity': arity,
                                        'treeDepth': depth,
                                        'timeLockPuzzleParam': timeLock,
                                        'tacitKnowledgeType':
                                            TacitKnowledgeTypes.hashviz,
                                        'tacitKnowledgeConfigs': {'size': size},
                                        'secretSeed': _passwordController.text,
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
              ElevatedButton(
                onPressed: () {
                  final arity = int.parse(_arityController.text);
                  final depth = int.parse(_depthController.text);
                  final timeLock = int.parse(_timeLockController.text);
                  final size = int.parse(_sizeController.text);

                  Future.delayed(
                    const Duration(seconds: 1),
                    () {
                      if (!context.mounted) return;
                      context.read<GreatWallBloc>().add(
                            GreatWallInitialized(
                              treeArity: arity,
                              treeDepth: depth,
                              timeLockPuzzleParam: timeLock,
                              tacitKnowledgeType: TacitKnowledgeTypes.hashviz,
                              tacitKnowledgeConfigs: {
                                'size': size,
                                'isSymmetric': false,
                                'numColors': 4
                              },
                              secretSeed: _passwordController.text,
                            ),
                          );
                      context.go(
                        '/${ConfirmationPage.routeName}',
                        extra: {
                          'previousRoute': HashvizTreeInputsPage.routeName
                        },
                      );
                    },
                  );
                },
                child: const Text('Start Derivation'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
