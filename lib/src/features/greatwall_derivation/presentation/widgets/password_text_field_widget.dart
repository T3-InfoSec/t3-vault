import 'package:flutter/material.dart';

/// A widget that represents a text field for checking the encryption key password.
class PasswordTextField extends StatelessWidget {
  final TextEditingController controller;

  const PasswordTextField({
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 306,
        height: 130,
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(25),
        ),
        child: TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(16.0),
          ),
          maxLines: null,
        ),
      ),
    );
  }
}
