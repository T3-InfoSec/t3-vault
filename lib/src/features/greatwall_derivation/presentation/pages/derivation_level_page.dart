import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:t3_vault/src/features/greatwall_derivation/presentation/bloc/derivation_level/derivation_level_bloc.dart';
import 'package:t3_vault/src/features/greatwall_derivation/presentation/bloc/derivation_level/derivation_level_event.dart';
import 'package:t3_vault/src/features/greatwall_derivation/presentation/bloc/derivation_level/derivation_level_state.dart';

import 'package:t3_vault/src/core/settings/presentation/pages/settings_page.dart';
import 'package:t3_vault/src/features/greatwall_derivation/presentation/pages/derivation_result_page.dart';
import 'package:t3_vault/src/features/greatwall_derivation/presentation/pages/tree_inputs_page.dart';

class DerivationLevelPage extends StatelessWidget {
  const DerivationLevelPage({super.key});

  static const routeName = 'derivation_level';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DerivationLevelBloc()..add(LoadArityIndexes()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('T3-Vault'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.go('/${TreeInputsPage.routeName}');
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
        body: Center(
          child: BlocBuilder<DerivationLevelBloc, DerivationLevelState>(
            builder: (context, state) {
              if (state is DerivationLevelLoaded) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Level 0 of 1:'),
                    const SizedBox(height: 10),
                    ...state.arityIndexes.map((index) {
                      return Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              context.read<DerivationLevelBloc>().add(SelectArityIndex(index));
                              context.go('/${DerivationResultPage.routeName}');
                            },
                            child: Text(index),
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    }),
                  ],
                );
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
