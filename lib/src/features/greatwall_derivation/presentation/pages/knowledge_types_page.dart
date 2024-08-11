import 'package:flutter/material.dart';

import 'package:t3_vault/src/features/greatwall_derivation/presentation/widgets/custom_elevated_button_widget.dart';

/// A page that displays a list of knowledge types for user selection.
///
/// The [KnowledgeTypesPage] class is a stateless widget that presents
/// a list of predefined knowledge types as buttons.
/// 
/// Currently, the knowledge types are hardcoded. In the future, this list will
/// be dynamically populated from the Greatwall dart module, which will provide the actual data.
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
            return CustomElevatedButton(
                text: type,
                onPressed: () {
                  // TODO: Implement functionality for each button
                });
          }).toList(),
        ),
      ),
    );
  }
}
