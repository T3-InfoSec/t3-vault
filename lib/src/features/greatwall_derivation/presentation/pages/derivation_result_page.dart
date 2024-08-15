import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:t3_vault/src/core/settings/presentation/pages/settings_page.dart';
import 'package:t3_vault/src/features/landing/presentation/pages/home_page.dart';

class DerivationResultPage extends StatefulWidget {
  const DerivationResultPage({super.key});

  static const routeName = 'derivation_result';

  @override
  DerivationResultPageState createState() => DerivationResultPageState();
}

class DerivationResultPageState extends State<DerivationResultPage> {
  // Temporarily Hardcoded result
  final String kaResult =
      "3bd62811a6386e35ab18ea341c9b9766dc7b7ee3b84049e6f71ca33f6e552b0cb652a42846b44131018394727ee49beb239f79570369bdda4b8092640b1976ed9fdd3be0878c01f91f2ee28667f5d510dc7fe19136257441eed5e40eafcca552bc05373f1fa05c4b73f3286dc9d1733fc49b45df1dbc9a5216cfdd0848b7177b";

  late final TextEditingController _resultController;

  @override
  void initState() {
    super.initState();
    _resultController = TextEditingController(text: kaResult);
  }

  @override
  void dispose() {
    _resultController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('T3-Vault'),
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
            const SizedBox(height: 10),
            const Text('KA Result:'),
            const SizedBox(height: 10),
            TextField(controller: _resultController),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                context.go(HomePage.routeName);
              },
              child: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
