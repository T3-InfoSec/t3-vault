import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:t3_vault/src/features/greatwall_derivation/presentation/widgets/custom_elevated_button_widget.dart';

/// NOTE: This home page serves as a placeholder for testing purposes until the final version of the page is ready.
/// It will be removed once it is no longer necessary and the definitive page is implemented.
/// Please do not rely on this page for any production or final implementations.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Greatwall TKBA protocol'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 40),
            CustomElevatedButton(
              text: 'Derive your hash',
              onPressed: () {
                context.go('/knowledge_types');
              },
            ),
            const SizedBox(height: 20),
            CustomElevatedButton(
              text: 'Practice on your derivation',
              onPressed: () {
                // TODO: Implement navigation to memorization assistant
              },
            ),
          ],
        ),
      ),
    );
  }
}
