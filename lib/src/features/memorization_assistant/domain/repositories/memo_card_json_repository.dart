import 'dart:convert';
import 'dart:io';

import 'package:t3_memassist/memory_assistant.dart';
import '../converters/memo_card_json_converter.dart';

class MemoCardRepository {
  final String filePath;

  MemoCardRepository({required this.filePath});

  /// Reads memo cards from a JSON file and returns a map of memo cards.
  ///
  /// This method attempts to read a JSON file located at [filePath]. If the file
  /// does not exist, it returns an empty map. The contents of the file are 
  /// expected to be a list of JSON objects representing memo cards.
  ///
  /// Each JSON object is converted to a [MemoCard] instance using 
  /// [MemoCardConverter.fromJson], and a corresponding ID is extracted from 
  /// the JSON object to serve as the key in the resulting map.
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

  /// Writes memo cards to a JSON file.
  ///
  /// This method takes a map of memo cards, [memoCardMap], and writes their 
  /// details to a JSON file located at [filePath]. Each entry in the map is 
  /// converted to JSON format using [MemoCardConverter.toJson], and an 
  /// additional 'id' field is included for each memo card, corresponding to 
  /// its key in the map.
  ///
  /// The resulting list of JSON objects is then encoded as a string and 
  /// written to the specified file. If the file does not exist, it will be 
  /// created.
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
