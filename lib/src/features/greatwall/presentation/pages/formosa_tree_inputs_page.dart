import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:great_wall/great_wall.dart';
import 'package:t3_formosa/formosa.dart';
import 'package:t3_memassist/memory_assistant.dart';
import 'package:t3_vault/src/common/cryptography/usecases/bip_39_generator.dart';
import 'package:t3_vault/src/common/cryptography/usecases/encryption_service.dart';
import 'package:t3_vault/src/common/cryptography/usecases/key_generator.dart';
import 'package:t3_vault/src/features/greatwall/presentation/widgets/deckname_promt_widget.dart';
import 'package:t3_vault/src/features/greatwall/presentation/widgets/eka_promt_widget.dart';
import 'package:t3_vault/src/features/greatwall/presentation/widgets/pa0_seed_promt_widget.dart';
import 'package:uuid/uuid.dart';

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
  final TextEditingController _passwordController = TextEditingController();

  final encryptionService = EncryptionService();
  final bip39generator = Bip39generator();
  final keyGenerator = KeyGenerator();

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
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.sync),
                      onPressed: () async {
                        String pa0Seed = bip39generator.generataSixWordsSeed();
                        await showDialog<String>(
                          context: context,
                          builder: (context) => Pa0SeedPromtWidget(pa0Seed: pa0Seed),
                        );
                        if (pa0Seed.isNotEmpty) {
                          _passwordController.text = pa0Seed;
                        }
                      },
                    ),
                  ],
                );
              }),
              const SizedBox(height: 10),
              BlocBuilder<MemoCardSetBloc, MemoCardSetState>(
                builder: (context, memoCardSetState) {
                  return ElevatedButton(
                    onPressed: (memoCardSetState is MemoCardSetAddSuccess)
                        ? null
                        : () async {
                          final generatedKey = keyGenerator.generateHexadecimalKey();
                          final eka = await showDialog<String>(
                            context: context,
                            builder: (context) => EKAPromptWidget(eka: generatedKey),
                          );
                          if (eka != null) {
                            if (!context.mounted) return;
                            final deckName = await showDialog<String>(
                              context: context,
                              builder: (context) => DecknamePromtWidget(),
                            );
                            if (deckName != null) {
                              final deckId = const Uuid().v4();
                              final deck = Deck(deckId, deckName);
                              final arity = int.parse(_arityController.text);
                              final depth = int.parse(_depthController.text);
                              final timeLock = int.parse(_timeLockController.text);
                              final encryptedPA0 = await encryptionService.encrypt(_passwordController.text, eka);
                              if (!context.mounted) return;
                              final theme = (context.read<FormosaBloc>().state
                                      as FormosaThemeSelectSuccess)
                                  .theme;

                              context.read<MemoCardSetBloc>().add(
                                MemoCardSetCardAdded(
                                  memoCard: EkaMemoCard(
                                    eka: 'question',
                                    deck: deck,
                                  ),
                                ),
                              );

                              context.read<MemoCardSetBloc>().add(
                                MemoCardSetCardAdded(
                                  memoCard: Pa0MemoCard(
                                    pa0: base64Encode(encryptedPA0),
                                    deck: deck,
                                  ),
                                ),
                              );

                              for (int i = 1; i <= depth; i++) {
                                context.read<MemoCardSetBloc>().add(
                                      MemoCardSetCardAdded(
                                        memoCard: TacitKnowledgeMemoCard(
                                          knowledge: {
                                            'treeArity': arity,
                                            'treeDepth': i,
                                            'timeLockPuzzleParam': timeLock,
                                            'tacitKnowledge': FormosaTacitKnowledge(
                                              configs: {'formosaTheme': theme},
                                            ),
                                          },
                                          deck: deck,
                                          title: 'Derivation Level $i Card'
                                        ),
                                      )  
                                );
                              }
                            }
                          }
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
                                  secretSeed: _passwordController.text,
                                ),
                              );
                          context.go(
                            '/${KnowledgeTypesPage.routeName}/$routeName/'
                            '${ConfirmationPage.routeName}',
                          );
                        },
                      );
                    },
                    child: const Text('Start Derivation'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
