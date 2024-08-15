import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:t3_vault/src/core/settings/presentation/pages/settings_page.dart';
import 'package:t3_vault/src/features/greatwall_derivation/presentation/pages/derivation_level_page.dart';
import 'package:t3_vault/src/features/greatwall_derivation/presentation/pages/knowledge_types_page.dart';

class TreeInputParametersPage extends StatefulWidget {
  const TreeInputParametersPage({super.key});

  static const routeName = 'tree_input_parameters';

  @override
  TreeInputParametersPageState createState() => TreeInputParametersPageState();
}

class TreeInputParametersPageState extends State<TreeInputParametersPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _tlpController = TextEditingController();
  final TextEditingController _depthController = TextEditingController();
  final TextEditingController _arityController = TextEditingController();

  String? _selectedTheme;
  final List<String> _themes = ["BIP39", "medieval fantasy", "sci-fi"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('T3-Vault'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/${KnowledgeTypesPage.routeName}');
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
            DropdownButton<String>(
              value: _selectedTheme,
              hint: const Text('Select Theme'),
              items: _themes.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _selectedTheme = value;
                });
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _tlpController,
              decoration: const InputDecoration(
                hintText: 'Choose TLP',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _depthController,
              decoration: const InputDecoration(
                hintText: 'Choose tree depth',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _arityController,
              decoration: const InputDecoration(
                hintText: 'Choose tree arity',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Password',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                context.go('/${DerivationLevelPage.routeName}');
              },
              child: const Text('Derive'),
            ),
          ],
        ),
      ),
    );
  }
}
