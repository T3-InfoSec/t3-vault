import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:great_wall/great_wall.dart';
import 'package:t3_vault/src/common/cryptography/usecases/bip_39_generator.dart';
import 'package:t3_vault/src/common/cryptography/usecases/encryption_service.dart';
import 'package:t3_vault/src/common/cryptography/usecases/key_generator.dart';
import 'package:t3_vault/src/features/greatwall/presentation/widgets/pa0_seed_promt_widget.dart';

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
  final TextEditingController _colorsNumberController = TextEditingController();
  final TextEditingController _saturationController = TextEditingController();
  final TextEditingController _brightnessController = TextEditingController();
  final TextEditingController _minHueController = TextEditingController();
  final TextEditingController _maxHueController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final encryptionService = EncryptionService();
  final bip39generator = Bip39generator();
  final keyGenerator = KeyGenerator();

  HashvizTreeInputsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.hashvizTreeInputsPageTitle),
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
                TextField(
                  controller: _sizeController,
                  decoration:
                      const InputDecoration(labelText: 'Hashviz block size'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _saturationController,
                  decoration: const InputDecoration(labelText: 'Saturation'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _brightnessController,
                  decoration: const InputDecoration(labelText: 'Brightness'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _minHueController,
                  decoration: const InputDecoration(labelText: 'Min Hue'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _maxHueController,
                  decoration: const InputDecoration(labelText: 'Max Hue'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _colorsNumberController,
                  decoration: const InputDecoration(labelText: 'Colors Number'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                BlocBuilder<GreatWallBloc, GreatWallState>(
                  builder: (context, state) {
                    bool isSymmetric = false;

                    if (state is GreatWallInputsInProgress) {
                      isSymmetric = state.isSymmetric;
                    }

                    return Row(
                      children: [
                        Checkbox(
                          value: isSymmetric,
                          onChanged: (bool? value) {
                            context.read<GreatWallBloc>().add(
                                  GreatWallSymmetricToggled(),
                                );
                          },
                        ),
                        const Text('Symmetric'),
                      ],
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
                            String pa0Seed =
                                bip39generator.generataSixWordsSeed();
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
                    final hashvizSize = int.parse(_sizeController.text);
                    final numColors = int.parse(_colorsNumberController.text);
                    final saturation = double.parse(_saturationController.text);
                    final brightness = double.parse(_brightnessController.text);
                    final minHue = int.parse(_minHueController.text);
                    final maxHue = int.parse(_maxHueController.text);

                    final state = context.read<GreatWallBloc>().state;
                    final isSymmetric = state is GreatWallInputsInProgress
                        ? state.isSymmetric
                        : false;

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
                                  configs: {
                                    'hashvizSize': hashvizSize,
                                    'isSymmetric': isSymmetric,
                                    'numColors': numColors,
                                    'saturation': saturation,
                                    'brightness': brightness,
                                    'minHue': minHue,
                                    'maxHue': maxHue,
                                  },
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
