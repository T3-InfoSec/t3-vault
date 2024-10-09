import 'dart:convert';
import 'dart:io';

import 'package:t3_memassist/memory_assistant.dart';
import '../converters/memo_card_json_converter.dart';

class MemoCardRepository {
  final String filePath;

  MemoCardRepository({required this.filePath});

  /// Reads memo cards from the JSON file and returns a Map<MemoCard, String>.
  Future<Map<String, MemoCard>> readMemoCards() async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return <String, MemoCard>{};
      }
      final contents = await file.readAsString();
      final jsonData = jsonDecode(contents) as List;

      final memoCardMap = <String, MemoCard>{};
      for (var json in jsonData) {
        final memoCard = MemoCardConverter.fromJson(json);
        final id = json['id'];
        memoCardMap[id] = memoCard;
      }
      return memoCardMap;
    } catch (e) {
      // TODO: Handle file read errors
      return <String, MemoCard>{};
    }
  }

  /// Writes memo cards to the JSON file.
  Future<void> writeMemoCards(Map<String, MemoCard> memoCardMap) async {
    final file = File(filePath);

    final jsonData = memoCardMap.entries
        .map((entry) => {
              ...MemoCardConverter.toJson(entry.value),
              'id': entry.key,
            })
        .toList();

    await file.writeAsString(jsonEncode(jsonData));
  }
}
