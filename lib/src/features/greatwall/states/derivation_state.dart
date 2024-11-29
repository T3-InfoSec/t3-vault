import 'package:flutter/material.dart';
import 'package:great_wall/great_wall.dart';

class DerivationState with ChangeNotifier {
  String _pa0Seed = "";
  TacitKnowledge? _tacitKnowledge;

  String get pa0Seed => _pa0Seed;

  TacitKnowledge? get tacitKnowledge => _tacitKnowledge;

  void updatePa0Seed(String seed) {
    _pa0Seed = seed;
    notifyListeners();
  }

    void updateTacitKnowledge(TacitKnowledge newValue) {
    _tacitKnowledge = newValue;
    notifyListeners();
  }
}