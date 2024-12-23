import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:t3_crypto_objects/crypto_objects.dart';
import 'package:t3_memassist/memory_assistant.dart';

abstract class MemoCardStrategy {
  Widget? buildRecoveryButton(BuildContext context, MemoCard memoCard);
  Widget buildTryButton(BuildContext context, MemoCard memoCard);

  Future<bool> isValid(String key, MemoCard memoCard) async {
    Eka eka = Eka.fromKey(key);
    try {
      await eka.decrypt(base64Decode(memoCard.knowledge['node']));
      return true;
    } catch (e) {
      debugPrint('Error decryting node: $e');
      return false;
    }
  }
}
