import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:t3_vault/src/features/greatwall_derivation/presentation/bloc/greatwall/greatwall_bloc.dart';
import 'package:t3_vault/src/features/greatwall_derivation/presentation/bloc/greatwall/greatwall_event.dart';
import 'package:t3_vault/src/features/greatwall_derivation/presentation/bloc/greatwall/greatwall_state.dart';

import 'package:t3_vault/src/core/settings/presentation/pages/settings_page.dart';
import 'package:t3_vault/src/features/greatwall_derivation/presentation/pages/confirmation_page.dart';
import 'package:t3_vault/src/features/greatwall_derivation/presentation/pages/knowledge_types_page.dart';

class TreeInputsPage extends StatelessWidget {
  TreeInputsPage({super.key});

  static const routeName = 'tree_inputs';

  final TextEditingController _arityController = TextEditingController();
  final TextEditingController _depthController = TextEditingController();
  final TextEditingController _timeLockController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('T3-Vault'),
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
      body: Column(
        children: [
          BlocBuilder<GreatWallBloc, GreatWallState>(
            builder: (context, state) {
              String? selectedOption;

              if (state is GreatWallFormosaThemeState) {
                selectedOption = state.selectedOption;
              }

              return DropdownButton<String>(
                value: selectedOption,
                hint: const Text('Select Theme'),
                items:
                    ["BIP39", "medieval fantasy", "sci-fi"].map((String value) { // TODO: Get Themes from t3-formosa-dart component
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
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
            obscureText: true, // TODO: obscure number of digits too
            decoration: const InputDecoration(hintText: 'Password'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              final arity = int.parse(_arityController.text);
              final depth = int.parse(_depthController.text);
              final timeLock = int.parse(_timeLockController.text);

              context.read<GreatWallBloc>().add(
                    InitializeGreatWall(
                      treeArity: arity,
                      treeDepth: depth,
                      timeLockPuzzleParam: timeLock,
                      seed: _passwordController.text,
                    ),
                  );

              context.go('/${ConfirmationPage.routeName}');
            },
            child: const Text('Start Derivation'),
          ),
        ],
      ),
    );
  }
}
