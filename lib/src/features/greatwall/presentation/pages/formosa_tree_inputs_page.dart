import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:great_wall/great_wall.dart';
import 'package:t3_crypto_objects/crypto_objects.dart';
import 'package:t3_vault/src/common/cryptography/presentation/widgets/sa0_mnemonic_input_widget.dart';

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

  FormosaTreeInputsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.formosaTreeInputsPageTitle),
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
                    hint: Text(AppLocalizations.of(context)!.theme),
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
              const SizedBox(height: 10),
              Sa0MnemonicInputWidget(passwordController: _passwordController),
              const SizedBox(height: 10),
              BlocBuilder<FormosaBloc, FormosaState>(
                builder: (context, state) {
                  bool isButtonEnabled = false;
                  if (state is FormosaMnemonicValidation) {
                    isButtonEnabled = state.isValid;
                  }

                  return ElevatedButton(
                    onPressed: isButtonEnabled
                        ? () async {
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
                                        sa0Mnemonic: _passwordController.text,
                                      ),
                                    );
                                context.go(
                                  '/${KnowledgeTypesPage.routeName}/$routeName/'
                                  '${ConfirmationPage.routeName}',
                                );
                              },
                            );
                          }
                        : null,
                    child: Text(AppLocalizations.of(context)!.startDerivation),
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
