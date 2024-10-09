import 'dart:convert';
import 'dart:io';

import 'package:t3_memassist/memory_assistant.dart';

import '../converters/memo_card_json_converter.dart';

class MemoCardRepository {
  final String filePath;

  MemoCardRepository({required this.filePath});

  /// Reads memo cards from the JSON file.
  Future<List<MemoCard>> readMemoCards() async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return <MemoCard>[];
      }
      final contents = await file.readAsString();
      final jsonData = jsonDecode(contents) as List;
      return jsonData.map((json) => MemoCardConverter.fromJson(json)).toList();
    } catch (e) {
      // TODO: Handle file read errors
      return <MemoCard>[];
    }
  }

  /// Writes memo cards to the JSON file.
  Future<void> writeMemoCards(List<MemoCard> memoCards) async {
    final file = File(filePath);
    final jsonData = memoCards.map((card) => MemoCardConverter.toJson(card)).toList();
    await file.writeAsString(jsonEncode(jsonData));
  }
}
