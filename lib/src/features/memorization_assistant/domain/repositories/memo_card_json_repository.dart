import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:t3_memassist/memory_assistant.dart';
import 'package:t3_vault/src/common/notifications/domain/notifications_service.dart';
import '../converters/memo_card_json_converter.dart';

class MemoCardRepository {
  final String filePath;
  final Set<MemoCard> _memoCards = {};
  final NotificationService notificationService;

  MemoCardRepository({required this.filePath, required this.notificationService});

  /// Reads memo cards from a JSON file and returns a list of memo cards.
  Future<List> readMemoCards() async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return [];
      }
      final contents = await file.readAsString();
      final jsonData = jsonDecode(contents) as List;

      _memoCards.clear();
      for (var json in jsonData) {
        final memoCard = MemoCardConverter.fromJson(json);
        _memoCards.add(memoCard);
      }
      return List.unmodifiable(_memoCards);
    } catch (e) {
      debugPrint('Error reading from repository: $e');
      return [];
    }
  }

  /// Adds a new memo card to the repository.
  Future<void> addMemoCard(List<MemoCard> memoCards) async {
    _memoCards.addAll(memoCards);
    await _writeMemoCards();
  }

  /// Removes a memo card from the repository by ID.
  Future<void> removeMemoCard(String id) async {
    _memoCards.removeWhere((card) => card.id == id);
    await _writeMemoCards();
  }

  /// Updates an existing memo card in the repository.
  Future<void> updateMemoCard(MemoCard memoCard) async {
    _memoCards.removeWhere((card) => card.id == memoCard.id);

    _memoCards.add(memoCard);

    await _writeMemoCards();
  }

  /// Writes the current list of memo cards to the JSON file.
  Future<void> _writeMemoCards() async {
    final file = File(filePath);

    final List<Map<String, dynamic>> jsonData = _memoCards.map((card) {
      _scheduleMemoCardReviewNotification(card);
      return MemoCardConverter.toJson(card);
    }).toList();

    await file.writeAsString(jsonEncode(jsonData));
  }

  Set<MemoCard> get memoCards => _memoCards;

  void _scheduleMemoCardReviewNotification(MemoCard card) {
    notificationService.scheduleNotification(
      id: card.id.hashCode,
      title: 'Time to review ${card.title}',
      body: 'You have a card to review!',
      scheduledDate: card.due.toLocal(),
      payload: jsonEncode(MemoCardConverter.toJson(card)),
    );
  }
}
