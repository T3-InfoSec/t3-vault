import 'package:flutter/material.dart';

class KnowledgeTypesActivity extends StatelessWidget {
  const KnowledgeTypesActivity({super.key});


  @override
  Widget build(BuildContext context) {
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
