import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:t3_vault/src/core/settings/presentation/pages/settings_page.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Outsource computation:'),
            const SizedBox(width: 10),
            Switch(
              value: _isToggled,
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
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16.0),
                hintText: "password",
                hintStyle: TextStyle(color: Colors.black),
              ),
              style: const TextStyle(color: Colors.black),
              maxLines: null,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                _checkPassword(context, _controller.text, _password);
              },
              child: const Text('Check password'),
            ),
            const SizedBox(height: 80),
            ElevatedButton(
              onPressed: () {
                // TODO
              },
              child: const Text('Correct'),
            ),
          ],
        ),
      ),
    );
  }

  /// Checks if the entered password matches the actual user password.
  void _checkPassword(
      BuildContext context, String inputPassword, String password) {
    final isPasswordCorrect = inputPassword == password;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Password check'),
          content: Text(isPasswordCorrect
              ? 'Password is correct!'
              : 'Password is incorrect!'),
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
