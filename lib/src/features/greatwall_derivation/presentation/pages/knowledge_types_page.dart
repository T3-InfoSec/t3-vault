import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:t3_vault/src/features/greatwall_derivation/presentation/widgets/custom_elevated_button_widget.dart';

class KnowledgeTypesPage extends StatelessWidget {
  const KnowledgeTypesPage({super.key});

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Greatwall TKBA Protocol'),
        backgroundColor: const Color(0xFF70A8FF),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: knowledgeTypes.map((type) {
            return Column(
              children: [
                CustomElevatedButton(
                  text: type,
                  onPressed: () {
                    context.go(
                        '/tree_input_parameters'); // TODO: Implement functionality for each button
                  },
                ),
                const SizedBox(height: 20),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
