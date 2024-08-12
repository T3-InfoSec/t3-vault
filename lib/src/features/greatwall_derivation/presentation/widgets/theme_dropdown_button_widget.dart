
import 'package:flutter/material.dart';

/// A dropdown button that allows users to select a theme.
class ThemeDropdownButton extends StatelessWidget {
  final String? selectedTheme;
  final List<String> themes;
  final ValueChanged<String?> onChanged;

  const ThemeDropdownButton({
    required this.selectedTheme,
    required this.themes,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedTheme,
      hint: const Text('Choose Theme'),
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Color(0xFF70A8FF)),
      underline: Container(
        height: 2,
        color: const Color(0xFF70A8FF),
      ),
      onChanged: onChanged,
      items: themes.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}