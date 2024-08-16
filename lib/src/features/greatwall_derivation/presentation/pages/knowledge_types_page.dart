import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:t3_vault/src/features/greatwall_derivation/presentation/pages/tree_inputs_page.dart';
import 'package:t3_vault/src/features/landing/presentation/pages/home_page.dart';

import '../../../../core/settings/presentation/pages/settings_page.dart';

class KnowledgeTypesPage extends StatelessWidget {
  static const routeName = 'knowledge_types';

  const KnowledgeTypesPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Temporarily hardcoded list of knowledge types
    final List<String> knowledgeTypes = [
      "Hashviz",
      "Formosa",
      "Fractal",
      "Voice"
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('T3-Vault'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go(HomePage.routeName);
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: knowledgeTypes.map((type) {
            return Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.go('/${TreeInputsPage.routeName}');
                  },
                  child: Text(type),
                ),
                const SizedBox(height: 10),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
