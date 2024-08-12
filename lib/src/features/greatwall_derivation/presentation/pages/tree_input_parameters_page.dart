import 'package:flutter/material.dart';

import 'package:t3_vault/src/features/greatwall_derivation/presentation/widgets/custom_elevated_button_widget.dart';
import 'package:t3_vault/src/features/greatwall_derivation/presentation/widgets/password_text_field_widget.dart';
import 'package:t3_vault/src/features/greatwall_derivation/presentation/widgets/theme_dropdown_button_widget.dart';

/// A page that allows users to configure tree input parameters for the derivation process.
///
/// The [TreeInputsParametersPage] class includes a dropdown to select a theme and several buttons
/// to configure TLP, tree depth, and tree arity. It also includes a password field and a
/// final "Derive" button.
class TreeInputsParametersPage extends StatefulWidget {
  const TreeInputsParametersPage({super.key});

  @override
  TreeInputsParametersPageState createState() =>
      TreeInputsParametersPageState();
}

class TreeInputsParametersPageState extends State<TreeInputsParametersPage> {
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedTheme;
  // Temporarily hardcoded list of themes
  final List<String> _themes = ["BIP39", "medieval fantasy", "sci-fi"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Tree Input Parameters'),
        backgroundColor: const Color(0xFF70A8FF),
      ),
      body: Padding(
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
            CustomElevatedButton(
                text: 'Choose TLP',
                onPressed: () {
                  // TODO: Implement functionality for this button
                }),
            const SizedBox(height: 20),
            CustomElevatedButton(
                text: 'Choose tree depth',
                onPressed: () {
                  // TODO: Implement functionality for this button
                }),
            const SizedBox(height: 20),
            CustomElevatedButton(
                text: 'Choose tree arity',
                onPressed: () {
                  // TODO: Implement functionality for this button
                }),
            const SizedBox(height: 30),
            PasswordTextField(controller: _passwordController),
            const SizedBox(height: 80),
            CustomElevatedButton(
                text: 'Derive',
                onPressed: () {
                  // TODO: Implement functionality for this button
                }),
          ],
        ),
      ),
    );
  }
}
