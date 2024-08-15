import 'package:flutter/material.dart';

/// A widget that represents a text field for checking the encryption key password.
class PasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;

  const PasswordTextField({
    required this.controller,
    this.hintText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(25),
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(16.0),
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.black),
          ),
          style: const TextStyle(color: Colors.black),
          maxLines: null,
        ),
      ),
    );
  }
}
