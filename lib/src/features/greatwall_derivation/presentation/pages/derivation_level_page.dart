import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:t3_vault/src/core/settings/presentation/pages/settings_page.dart';
import 'package:t3_vault/src/features/greatwall_derivation/presentation/pages/derivation_result_page.dart';
import 'package:t3_vault/src/features/greatwall_derivation/presentation/pages/tree_input_parameters_page.dart';

class DerivationLevelPage extends StatelessWidget {
  const DerivationLevelPage({super.key});

  static const routeName = 'derivation_level';

  @override
  Widget build(BuildContext context) {
    // Lista temporal de índices de aridad
    final List<String> arityIndexes = [
      "moment weapon pact",
      "bone exact certain",
      "affair muffin display",
      "net cancel snack"
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('T3-Vault'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/${TreeInputParametersPage.routeName}');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            // iconSize: 300,
            onPressed: () {
              context.go('/${SettingsPage.routeName}');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Level 0 of 1:'),
            const SizedBox(height: 10),
            ...arityIndexes.map((index) {
              return Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.go('/${DerivationResultPage.routeName}');
                    },
                    child: Text(index),
                  ),
                  const SizedBox(height: 10),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
