import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:t3_vault/src/features/greatwall_derivation/presentation/bloc/tree_inputs/tree_inputs_bloc.dart';

import 'package:t3_vault/src/core/settings/presentation/pages/settings_page.dart';
import 'package:t3_vault/src/features/greatwall_derivation/presentation/bloc/tree_inputs/tree_inputs_event.dart';
import 'package:t3_vault/src/features/greatwall_derivation/presentation/bloc/tree_inputs/tree_inputs_state.dart';
import 'package:t3_vault/src/features/greatwall_derivation/presentation/pages/derivation_level_page.dart';
import 'package:t3_vault/src/features/greatwall_derivation/presentation/pages/knowledge_types_page.dart';

class TreeInputsPage extends StatelessWidget {
  const TreeInputsPage({super.key});

  static const routeName = 'tree_input_parameters';

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
      body: BlocProvider(
        create: (context) => TreeInputsBloc(),
        child: Center(
          child: BlocBuilder<TreeInputsBloc, TreeInputsState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DropdownButton<String>(
                    value: state.selectedTheme,
                    hint: const Text('Select Theme'),
                    items: ["BIP39", "medieval fantasy", "sci-fi"].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      context.read<TreeInputsBloc>().add(ThemeChanged(value));
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    onChanged: (value) {
                      context.read<TreeInputsBloc>().add(TlpChanged(value));
                    },
                    decoration: const InputDecoration(
                      hintText: 'Choose TLP',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    onChanged: (value) {
                      context.read<TreeInputsBloc>().add(DepthChanged(value));
                    },
                    decoration: const InputDecoration(
                      hintText: 'Choose tree depth',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    onChanged: (value) {
                      context.read<TreeInputsBloc>().add(ArityChanged(value));
                    },
                    decoration: const InputDecoration(
                      hintText: 'Choose tree arity',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    onChanged: (value) {
                      context.read<TreeInputsBloc>().add(PasswordChanged(value));
                    },
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      context.go('/${DerivationLevelPage.routeName}');
                    },
                    child: const Text('Derive'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
