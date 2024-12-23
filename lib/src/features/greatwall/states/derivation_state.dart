import 'package:flutter/material.dart';
import 'package:great_wall/great_wall.dart';

class DerivationState with ChangeNotifier {
  String _sa0Mnemonic = "";
  TacitKnowledge? _tacitKnowledge;

  String get sa0Mnemonic => _sa0Mnemonic;

  TacitKnowledge? get tacitKnowledge => _tacitKnowledge;

  void updateSa0Mnemonic(String sa0Mnemonic) {
    _sa0Mnemonic = sa0Mnemonic;
    notifyListeners();
  }

    void updateTacitKnowledge(TacitKnowledge newValue) {
    _tacitKnowledge = newValue;
    notifyListeners();
  }
}