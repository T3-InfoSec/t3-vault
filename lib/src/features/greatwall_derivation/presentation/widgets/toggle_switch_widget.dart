import 'package:flutter/material.dart';

import 'package:t3_vault/src/features/greatwall_derivation/presentation/pages/secure_configurations_page.dart';

/// A widget that represents a toggle switch for [SecureConfigPage]
class ToggleSwitch extends StatelessWidget {
  final bool isToggled;
  final ValueChanged<bool> onChanged;

  const ToggleSwitch({
    required this.isToggled,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Outsource computation:'),
        const SizedBox(width: 10),
        Switch(
          value: isToggled,
          onChanged: onChanged,
          activeColor: const Color(0xFF70A8FF),
          inactiveThumbColor: Colors.grey,
        ),
      ],
    );
  }
}
