import 'package:flutter/material.dart';
import 'package:great_wall/great_wall.dart';

class DerivationState with ChangeNotifier {
  String _password = "";
  TacitKnowledge? _tacitKnowledge;

  String get password => _password;

  TacitKnowledge? get tacitKnowledge => _tacitKnowledge;

  void updatePassword(String newValue) {
    _password = newValue;
    notifyListeners();
  }

    void updateTacitKnowledge(TacitKnowledge newValue) {
    _tacitKnowledge = newValue;
    notifyListeners();
  }
}