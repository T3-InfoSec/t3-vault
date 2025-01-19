import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:t3_memassist/memory_assistant.dart';
import 'package:t3_vault/src/common/notifications/domain/notifications_service.dart';
import 'package:t3_vault/src/features/memorization_assistant/domain/converters/intermediate_derivation_state_converter.dart';
import 'package:t3_vault/src/features/memorization_assistant/domain/converters/memo_card_json_converter.dart';
import 'package:t3_vault/src/features/memorization_assistant/domain/entities/intermediate_derivation_state_entity.dart';

class ProfileRepository {
  final String filePath;
  final Set<MemoCard> _memoCards = {};
  final List<IntermediateDerivationStateEntity> _intermediateStates = [];
  final NotificationService notificationService;

  ProfileRepository(
      {required this.filePath, required this.notificationService});

  /// Reads memo cards and intermediate states from a JSON file and update [_memoCards] and [_intermediateStates].
  Future<void> readProfile() async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return;
      }
      final contents = await file.readAsString();
      final jsonData = jsonDecode(contents) as Map<String, dynamic>;

      // Processing memoCards
      final memoCardsJson = jsonData['memoCards'] as List;
      _memoCards.clear();
      for (var json in memoCardsJson) {
        final memoCard = MemoCardConverter.fromJson(json);
        _memoCards.add(memoCard);
      }

      // Processing intermediateStates
      final statesJson = jsonData['intermediateStates'] as List;
      _intermediateStates
        ..clear()
        ..addAll(statesJson.map((json) => IntermediateDerivationStateConverter.fromJson(json)).toList());
    } catch (e) {
      debugPrint('Error reading profile: $e');
    }
  }

  /// Writes [_memoCards] and [_intermediateStates] to the JSON file.
  Future<void> writeProfile() async {
    final file = File(filePath);

    final jsonData = {
      'memoCards': _memoCards.map((card) {
        _scheduleMemoCardReviewNotification(card);
        return MemoCardConverter.toJson(card);
      }).toList(),
      'intermediateStates': _intermediateStates
          .map((state) => IntermediateDerivationStateConverter.toJson(state))
          .toList(),
    };

    await file.writeAsString(jsonEncode(jsonData));
  }

  /// Adds a new memo card to the repository.
  Future<void> addMemoCards(List<MemoCard> memoCards) async {
    _memoCards.addAll(memoCards);
    await writeProfile();
  }

  /// Removes a memo card from the repository by ID.
  Future<void> removeMemoCard(String id) async {
    _memoCards.removeWhere((card) => card.id == id);
    await writeProfile();
  }

  /// Updates an existing memo card in the repository.
  Future<void> updateMemoCard(MemoCard memoCard) async {
    _memoCards.removeWhere((card) => card.id == memoCard.id);
    _memoCards.add(memoCard);
    await writeProfile();
  }

  /// Adds a new intermediate State to the repository.
  Future<void> addIntermediateState(IntermediateDerivationStateEntity state) async {
    _intermediateStates.add(state);
    await writeProfile();
  }

  Set<MemoCard> get memoCards => Set.unmodifiable(_memoCards);

  List<String> get intermediateStates => List.unmodifiable(_intermediateStates);

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
