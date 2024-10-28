import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:great_wall/great_wall.dart';
import 'package:t3_memassist/memory_assistant.dart';
import 'package:t3_vault/src/features/greatwall/domain/usecases/encryption_service.dart';
import 'package:t3_vault/src/features/memorization_assistant/domain/models/profile_model.dart';

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
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _colorsNumberController = TextEditingController();
  final TextEditingController _saturationController = TextEditingController();
  final TextEditingController _brightnessController = TextEditingController();
  final TextEditingController _minHueController = TextEditingController();
  final TextEditingController _maxHueController = TextEditingController();

  final encryptionService = EncryptionService();

  HashvizTreeInputsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hashviz Input Parameters'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.read<ProfilesBloc>().add(ProfileSetUnchanged());
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
                  decoration: const InputDecoration(
                      labelText: 'Time Lock Puzzle Param'),
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
                BlocBuilder<ProfilesBloc, ProfileSetState>(
                  builder: (context, profileSetState) {
                    return ElevatedButton(
                      onPressed: (profileSetState is ProfileSetAddSuccess)
                          ? null
                          : () async {
                              final arity = int.parse(_arityController.text);
                              final depth = int.parse(_depthController.text);
                              final timeLock =
                                  int.parse(_timeLockController.text);
                              final hashvizSize = int.parse(_sizeController.text);
                              final numColors =
                                  int.parse(_colorsNumberController.text);
                              final saturation =
                                  double.parse(_saturationController.text);
                              final brightness =
                                  double.parse(_brightnessController.text);
                              final minHue = int.parse(_minHueController.text);
                              final maxHue = int.parse(_maxHueController.text);

                              final state = context.read<GreatWallBloc>().state;
                              final isSymmetric =
                                  state is GreatWallInputsInProgress
                                      ? state.isSymmetric
                                      : false;

                          // TODO: Use auto-generated real keys.
                          String eka = "EphemeralKeyMock";
                          String pa0 = "encrypted_6-words_hashviz_seed";
                          var encryptedPA0 = await encryptionService.encryptPA0(pa0, eka);

                          if (!context.mounted) return;
                          context.read<ProfilesBloc>().add(
                                ProfileSetAdded(
                                  profile: Profile(
                                    memoCard:
                                      MemoCard(
                                        knowledge: {
                                          'treeArity': arity,
                                          'treeDepth': depth,
                                          'timeLockPuzzleParam': timeLock,
                                          'tacitKnowledge': HashVizTacitKnowledge(
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
                                          'secretSeed': _passwordController.text,
                                        },
                                      ),
                                    seedPA0: base64Encode(encryptedPA0)
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
              child: const Text('Start Derivation'),
            ),
          ],
        ),
      ),),),
    );
  }
}
