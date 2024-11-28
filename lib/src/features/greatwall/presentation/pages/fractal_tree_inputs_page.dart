import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:great_wall/great_wall.dart';
import 'package:t3_vault/src/common/cryptography/presentation/widgets/pa0_seed_promt_widget.dart';

import '../../../../common/settings/presentation/pages/settings_page.dart';
import '../../../memorization_assistant/presentation/blocs/blocs.dart';
import '../blocs/blocs.dart';
import 'confirmation_page.dart';
import 'knowledge_types_page.dart';

class FractalTreeInputsPage extends StatelessWidget {
  static const routeName = 'fractal_inputs';

  final TextEditingController _arityController = TextEditingController();
  final TextEditingController _depthController = TextEditingController();
  final TextEditingController _timeLockController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  FractalTreeInputsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.fractalTreeInputsPageTitle),
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _arityController,
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.treeArity),
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
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.treeDepth),
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
                  decoration: InputDecoration(
                      labelText:
                          AppLocalizations.of(context)!.timeLockPuzzleParam),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    context.read<GreatWallBloc>().add(
                          GreatWallTimeLockChanged(_timeLockController.text),
                        );
                  },
                ),
                const SizedBox(height: 20),
                BlocBuilder<GreatWallBloc, GreatWallState>(
                  builder: (context, state) {
                    bool isPasswordVisible = false;

                    if (state is GreatWallInputsInProgress) {
                      isPasswordVisible = state.isPasswordVisible;
                    }

                    return Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _passwordController,
                            obscureText: !isPasswordVisible,
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)!.password,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  context.read<GreatWallBloc>().add(
                                      GreatWallPasswordVisibilityToggled());
                                },
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.sync),
                          onPressed: () async {
                            String pa0Seed = Pa0().seed;
                            await showDialog<String>(
                              context: context,
                              builder: (context) =>
                                  Pa0SeedPromtWidget(pa0Seed: pa0Seed),
                            );
                            if (pa0Seed.isNotEmpty) {
                              _passwordController.text = pa0Seed;
                            }
                          },
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    final arity = int.parse(_arityController.text);
                    final depth = int.parse(_depthController.text);
                    final timeLock = int.parse(_timeLockController.text);

                    Future.delayed(
                      const Duration(seconds: 1),
                      () {
                        if (!context.mounted) return;
                        context.read<GreatWallBloc>().add(
                              GreatWallInitialized(
                                treeArity: arity,
                                treeDepth: depth,
                                timeLockPuzzleParam: timeLock,
                                tacitKnowledge: FractalTacitKnowledge( // TODO: pending to merge PR
                                  configs: {
                                    'funcType': 'burningship',
                                    'xMin': -2.5,
                                    'xMax': 2.0,
                                    'yMin': -2.0,
                                    'yMax': 0.8,
                                    'realP': 2.0,
                                    'imagP': 0.0,
                                    'width': 1024,
                                    'height': 1024,
                                    'escapeRadius': 4,
                                    'maxIters': 30,
                                  },
                                ),
                                pa0Seed: _passwordController.text,
                              ),
                            );
                        context.go(
                          '/${KnowledgeTypesPage.routeName}/$routeName/'
                          '${ConfirmationPage.routeName}',
                        );
                      },
                    );
                  },
                  child: Text(AppLocalizations.of(context)!.startDerivation),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
