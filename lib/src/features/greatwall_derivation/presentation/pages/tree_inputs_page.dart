import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:t3_formosa/formosa.dart';

import '../../../../common/settings/presentation/pages/settings_page.dart';
import '../blocs/greatwall/greatwall_bloc.dart';
import '../blocs/greatwall/greatwall_event.dart';
import '../blocs/greatwall/greatwall_state.dart';
import 'confirmation_page.dart';
import 'knowledge_types_page.dart';

class TreeInputsPage extends StatelessWidget {
  static const routeName = 'tree_inputs';

  final TextEditingController _arityController = TextEditingController();
  final TextEditingController _depthController = TextEditingController();
  final TextEditingController _timeLockController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  TreeInputsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Parameters'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            BlocBuilder<GreatWallBloc, GreatWallState>(
              builder: (context, state) {
                String? selectedOption;

                if (state is GreatWallFormosaThemeSelectSuccess) {
                  selectedOption = state.theme;
                }

                return DropdownButton<String>(
                  value: selectedOption,
                  hint: const Text('Select Theme'),
                  items: FormosaTheme.values.map((FormosaTheme theme) {
                    return DropdownMenuItem<String>(
                      value: theme.label,
                      child: Text(theme.label),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      context
                          .read<GreatWallBloc>()
                          .add(GreatWallFormosaThemeSelected(newValue));
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
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(hintText: 'Password'),
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
                            secretSeed: _passwordController.text,
                          ),
                        );
                    context.go('/${ConfirmationPage.routeName}');
                  },
                );
              },
              child: const Text('Start Derivation'),
            ),
          ],
        ),
      ),
    );
  }
}
