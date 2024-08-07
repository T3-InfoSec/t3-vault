import 'package:flutter/material.dart';
import 'package:greatwall_protocol_flutter/knowledge_types_activity.dart';

class SecureConfigActivity extends StatefulWidget {
  const SecureConfigActivity({super.key});

  @override
  SecureConfigActivityState createState() => SecureConfigActivityState();
}

class SecureConfigActivityState extends State<SecureConfigActivity> {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                  activeColor: const Color(0xFF70A8FF),
                  inactiveThumbColor: Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text('Check encryption key:'),
            const SizedBox(height: 20),
            Center(
              child: Container(
                width: 306,
                height: 130,
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16.0),
                  ),
                  maxLines: null,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: SizedBox(
                width: 306,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF70A8FF),
                  ),
                  onPressed: () => _checkPassword(context, _controller.text, _password),
                  child: const Text('Check password'),
                ),
              ),
            ),
            const SizedBox(height: 80),
            Center(
              child: SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF70A8FF),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const KnowledgeTypesActivity(),
                      ),
                    );
                  },
                  child: const Text('Correct'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
