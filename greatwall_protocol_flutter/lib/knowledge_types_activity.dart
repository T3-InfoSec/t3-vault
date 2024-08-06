import 'package:flutter/material.dart';

/// A widget that displays a list of knowledge types for user selection.
///
/// The [KnowledgeTypesActivity] class is a stateless widget that presents 
/// a list of predefined knowledge types as buttons. 
/// Currently, the knowledge types are hardcoded. In the future, this list will
/// be dynamically populated from the Greatwall module, which will provide the actual data.
class KnowledgeTypesActivity extends StatelessWidget {
  const KnowledgeTypesActivity({super.key});


  @override
  Widget build(BuildContext context) {
    // Temporarily hardcoded list of knowledge types
    // TODO import great-wall-dart with actual knowledge types
    final List<String> knowledgeTypes = ["Hashviz", "Formosa", "Fractal", "Voice"];

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
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF70A8FF),
                  ),
                  onPressed: () {
                    // TODO: implement functionality for each button
                  },
                  child: Text(type),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
