import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:t3_vault/src/features/greatwall_derivation/presentation/widgets/custom_elevated_button_widget.dart';

class DerivationLevelPage extends StatelessWidget {
  const DerivationLevelPage({super.key});

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Derivation Level'),
        backgroundColor: const Color(0xFF70A8FF),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Level 0 of 1:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ...arityIndexes.map((type) {
              return Column(
                children: [
                  CustomElevatedButton(
                    text: type,
                    onPressed: () {
                      context.go(
                        '/derivation_result'); // TODO: Implement functionality for each button
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
