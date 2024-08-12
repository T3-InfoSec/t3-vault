import 'package:flutter/material.dart';

import 'package:t3_vault/src/features/greatwall_derivation/presentation/pages/knowledge_types_page.dart';

import 'package:t3_vault/src/features/greatwall_derivation/presentation/widgets/custom_elevated_button_widget.dart';
import 'package:t3_vault/src/features/greatwall_derivation/presentation/widgets/password_text_field_widget.dart';
import 'package:t3_vault/src/features/greatwall_derivation/presentation/widgets/toggle_switch_widget.dart';

/// NOTE: This class is not part of the MVP and is currently disabled. 
/// In the future, it may be revisited to add configuration and validation of derivation parameters.
///
/// It allows users to configure security preferences and parameters for the Greatwall TKBA protocol.
///
/// The [SecureConfigPage] class provides a user interface for configuring and validating
/// security-related preferences and protocol parameters.
/// 
/// Currently, it includes options to toggle 
/// outsourced computation and check an encryption key password.
class SecureConfigPage extends StatefulWidget {
  const SecureConfigPage({super.key});

  @override
  SecureConfigPageState createState() => SecureConfigPageState();
}

class SecureConfigPageState extends State<SecureConfigPage> {
  final TextEditingController _controller = TextEditingController();
  bool _isToggled = false;
  static const String _password = "password"; // Temporarily Hardcoded Password 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Greatwall TKBA Protocol'),
        backgroundColor: const Color(0xFF70A8FF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ToggleSwitch(
              isToggled: _isToggled,
              onChanged: (bool value) {
                setState(() {
                  _isToggled = value;
                  // TODO implement outsource computation logic.
                });
              },
            ),
            const SizedBox(height: 30),
            const Text('Check encryption key:'),
            const SizedBox(height: 20),
            PasswordTextField(controller: _controller),
            const SizedBox(height: 30),
            CustomElevatedButton(
              text: 'Check password',
              onPressed: () => _checkPassword(context, _controller.text, _password),
            ),
            const SizedBox(height: 80),
            CustomElevatedButton(
              text: 'Correct',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const KnowledgeTypesPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Checks if the entered password matches the actual user password.
  void _checkPassword(BuildContext context, String inputPassword, String password) {
    final isPasswordCorrect = inputPassword == password;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Password check'),
          content: Text(isPasswordCorrect ? 'Password is correct!' : 'Password is incorrect!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
