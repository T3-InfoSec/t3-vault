import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/settings/presentation/pages/settings_page.dart';
import 'formosa_tree_inputs_page.dart';
import 'hashviz_tree_inputs_page.dart';

class KnowledgeTypesPage extends StatelessWidget {
  static const routeName = 'knowledge';

  const KnowledgeTypesPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, String> knowledgeTypeRoutes = {
      "Hashviz": HashvizTreeInputsPage.routeName,
      "Formosa": FormosaTreeInputsPage.routeName,
      "Fractal": "/fractal_page",
      "Voice": "/voice_page",
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tacit Knowledge Types'),
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
          children: knowledgeTypeRoutes.entries.map(
            (entry) {
              return Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.go(
                        '/${KnowledgeTypesPage.routeName}/${entry.value}',
                      );
                    },
                    child: Text(entry.key),
                  ),
                  const SizedBox(height: 10),
                ],
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
