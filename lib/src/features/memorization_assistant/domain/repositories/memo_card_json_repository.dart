import 'dart:convert';
import 'dart:io';

import 'package:t3_memassist/memory_assistant.dart';
import '../converters/memo_card_json_converter.dart';

class MemoCardRepository {
  final String filePath;
  final Map<String, MemoCard> _memoCardIdMap = {};

  MemoCardRepository({required this.filePath}) {
    _loadMemoCardsFromFile();
  }

  /// Load memo cards from json file
  /// 
  /// This method initialises the map of ids and memocards
  /// with the persisted values using the internal logic 
  /// of the [readMemoCards] method.
  Future<void> _loadMemoCardsFromFile() async {
    await readMemoCards();
  }

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

  /// Writes memo cards to a JSON file.
  ///
  /// This method takes a list of memo cards, [memoCards], and writes their 
  /// details to a JSON file located at [filePath]. Each memo card in the 
  /// list is converted to JSON format using [MemoCardConverter.toJson], 
  /// and a unique 'id' field is generated for each memo card.
  ///
  /// The resulting list of JSON objects is then encoded as a string and 
  /// written to the specified file. If the file does not exist, it will be 
  /// created.
  Future<void> writeMemoCards(List<MemoCard> memoCards) async {
    final file = File(filePath);

    _memoCardIdMap.clear();

    final jsonData = memoCards.map((memoCard) {
      final id = MemoCardConverter.generateId();
      _memoCardIdMap[id] = memoCard;
      return {
        ...MemoCardConverter.toJson(memoCard),
        'id': id,
      };
    }).toList();

    await file.writeAsString(jsonEncode(jsonData));
  }
}
