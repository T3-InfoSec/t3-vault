import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:great_wall/great_wall.dart';

import 'package:t3_vault/src/features/greatwall_derivation/presentation/widgets/custom_elevated_button_widget.dart';
import 'package:t3_vault/src/features/greatwall_derivation/presentation/widgets/custom_text_field_widget.dart';
import 'package:t3_vault/src/features/greatwall_derivation/presentation/widgets/password_text_field_widget.dart';
import 'package:t3_vault/src/features/greatwall_derivation/presentation/widgets/theme_dropdown_button_widget.dart';

class TreeInputsParametersPage extends StatefulWidget {
  const TreeInputsParametersPage({super.key});

  @override
  TreeInputsParametersPageState createState() =>
      TreeInputsParametersPageState();
}

class TreeInputsParametersPageState extends State<TreeInputsParametersPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _tlpController = TextEditingController();
  final TextEditingController _depthController = TextEditingController();
  final TextEditingController _arityController = TextEditingController();

  String? _selectedTheme;
  final List<String> _themes = ["BIP39", "medieval fantasy", "sci-fi"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Tree Input Parameters'),
        backgroundColor: const Color(0xFF70A8FF),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ThemeDropdownButton(
              selectedTheme: _selectedTheme,
              themes: _themes,
              onChanged: (String? value) {
                setState(() {
                  _selectedTheme = value;
                });
              },
            ),
            const SizedBox(height: 20),
            CustomTextField(
              hintText: 'Choose TLP',
              controller: _tlpController,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              hintText: 'Choose tree depth',
              controller: _depthController,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              hintText: 'Choose tree arity',
              controller: _arityController,
            ),
            const SizedBox(height: 30),
            PasswordTextField(controller: _passwordController),
            const SizedBox(height: 80),
            CustomElevatedButton(
                text: 'Derive',
                onPressed: () {
                  GreatWall greatWall = GreatWall(
                      treeArity: int.tryParse(_arityController.text) ?? 0,
                      treeDepth: int.tryParse(_depthController.text) ?? 0,
                      timeLockPuzzleParam:
                          int.tryParse(_tlpController.text) ?? 0);
                  greatWall.seed0 = _passwordController.text;
                  context.go('/derivation_level');
                }),
          ],
        ),
      ),
    );
  }
}
