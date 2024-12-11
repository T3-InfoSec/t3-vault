import 'package:flutter/material.dart';
import 'package:great_wall/great_wall.dart';
import 'package:t3_memassist/memory_assistant.dart';

abstract class MemoCardStrategy {
  Widget? buildRecoveryButton(BuildContext context, MemoCard memoCard);
  Widget buildTryButton(BuildContext context, MemoCard memoCard);

  Future<bool> isValid(String key, MemoCard memoCard) async {
    Eka eka = Eka(key: key);
    try {
      await eka.decryptToNode(memoCard.knowledge['node']);
      return true;
    } catch (e) {
      debugPrint('Error decryting node: $e');
      return false;
    }
  }
}
