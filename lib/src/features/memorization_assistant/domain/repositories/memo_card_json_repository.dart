import 'dart:convert';
import 'dart:io';

import 'package:t3_memassist/memory_assistant.dart';
import '../converters/memo_card_json_converter.dart';

class MemoCardRepository {
  final String filePath;
  Map<String, MemoCard> _memoCardIdMap = {};

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
  Future<List> readMemoCards() async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return [];
      }
      final contents = await file.readAsString();
      final jsonData = jsonDecode(contents) as List;

      for (var json in jsonData) {
        final memoCard = MemoCardConverter.fromJson(json);
        final id = json['id'];
        _memoCardIdMap[id] = memoCard;
      }
      return _memoCardIdMap.values.toList();
    } catch (e) {
      // TODO: Handle file read errors
      return [];
    }
  }

  /// Adds a new memo card to the repository.
  ///
  /// This method generates a unique ID for the provided [memoCard] and adds 
  /// it to the internal map [_memoCardIdMap]. The updated map is then written 
  /// to the JSON file located at [filePath] using [_writeMemoCard] method.
  Future<void> addMemoCard(MemoCard memoCard) async {
    final id = MemoCardConverter.generateId();
    _memoCardIdMap[id] = memoCard;
    
    await _writeMemoCards();
  }

  /// Removes a memo card from the repository.
  ///
  /// This method identifies the ID of the provided [memoCard] from 
  /// [_memoCardIdMap] and removes it from the map. The updated map is then 
  /// written to the JSON file at [filePath] using [_writeMemoCard] method.
  Future<void> removeMemoCard(MemoCard memoCard) async {
    final id = _getMemoCardId(memoCard);
    if (id != null) {
      _memoCardIdMap.remove(id);
    }
    
    await _writeMemoCards();
  }

  /// Updates an existing memo card in the repository.
  ///
  /// This method locates the ID of the provided [memoCard] in [_memoCardIdMap] 
  /// and updates its content. The updated map is then written 
  /// to the JSON file located at [filePath] using [_writeMemoCard] method.
  Future<void> updateMemoCard(MemoCard memoCard) async {
    final id = _getMemoCardId(memoCard);
    if (id != null) {
      _memoCardIdMap[id] = memoCard;
    }

    await _writeMemoCards();
  }

  /// Writes the current state of memo cards to the JSON file.
  ///
  /// This private method converts the current entries in [_memoCardIdMap] 
  /// to JSON format using [MemoCardConverter.toJson], adds their corresponding 
  /// IDs, and writes the resulting list to the file located at [filePath].
  ///
  /// If the file does not exist, it will be created.  
  Future<void> _writeMemoCards() async {
    final file = File(filePath);
    final jsonData = _memoCardIdMap.entries.map((entry) => {
      ...MemoCardConverter.toJson(entry.value),
      'id': entry.key,
    }).toList();
    await file.writeAsString(jsonEncode(jsonData));
  }

  Map<String, MemoCard> get memoCardIdMap => _memoCardIdMap;

  /// Retrieves the ID of a memo card.
  ///
  /// This private method searches [_memoCardIdMap] for the provided [memoCard] 
  /// and returns its corresponding ID. If the memo card is not found, the method 
  /// returns `null`.
  String? _getMemoCardId(MemoCard memoCard) {
    return _memoCardIdMap.entries.firstWhere((entry) => entry.value == memoCard).key;
  }
}
