import 'package:flutter/material.dart';
import 'package:great_wall/great_wall.dart';
import 'package:t3_crypto_objects/crypto_objects.dart';

class DerivationState with ChangeNotifier {
  String _sa0Mnemonic = "";
  TacitKnowledge? _tacitKnowledge;
  Eka? _eka;

  String get sa0Mnemonic => _sa0Mnemonic;

  TacitKnowledge? get tacitKnowledge => _tacitKnowledge;

  Eka? get eka => _eka;

  void updateSa0Mnemonic(String sa0Mnemonic) {
    _sa0Mnemonic = sa0Mnemonic;
    notifyListeners();
  }

  void updateTacitKnowledge(TacitKnowledge newValue) {
    _tacitKnowledge = newValue;
    notifyListeners();
  }

  void updateEka(Eka newValue) {
    _eka = newValue;
    notifyListeners();
  }
}