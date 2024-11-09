import 'package:flutter/material.dart';

class DerivationState with ChangeNotifier {
  String _password = "";

  // Getter para acceder al valor
  String get password => _password;

  // Método para actualizar el valor
  void updatePassword(String newValue) {
    _password = newValue;
    notifyListeners();
  }
}