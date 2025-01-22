import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:t3_memassist/memory_assistant.dart';
import 'package:t3_vault/src/common/notifications/domain/notifications_service.dart';
import 'package:t3_vault/src/features/memorization_assistant/domain/converters/ongoing_derivation_converter.dart';
import 'package:t3_vault/src/features/memorization_assistant/domain/converters/memo_card_json_converter.dart';
import 'package:t3_vault/src/features/memorization_assistant/domain/entities/intermediate_derivation_state_entity.dart';
import 'package:t3_vault/src/features/memorization_assistant/domain/entities/ongoing_derivation_entity.dart';

class ProfileRepository {
  final String filePath;
  final Set<MemoCard> _memoCards = {};
  OngoingDerivationEntity? _ongoingDerivation;
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

      // Processing ongoingDerivation
      if (jsonData['ongoingDerivation'] != null) {
        _ongoingDerivation = OngoingDerivationConverter.fromJson(jsonData['ongoingDerivation']);
      }
    } catch (e) {
      debugPrint('Error reading profile: $e');
    }
  }

  /// Writes [_memoCards] and [_ongoingDerivation] to the JSON file.
  Future<void> writeProfile() async {
    final file = File(filePath);

    final jsonData = {
      'memoCards': _memoCards.map((card) {
        _scheduleMemoCardReviewNotification(card);
        return MemoCardConverter.toJson(card);
      }).toList(),
      'ongoingDerivation': _ongoingDerivation != null
          ? OngoingDerivationConverter.toJson(_ongoingDerivation!)
          : null,
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

  /// Sets the ongoing derivation in the repository.
  Future<void> setOngoingDerivation(OngoingDerivationEntity derivation) async {
    _ongoingDerivation = derivation;
    await writeProfile();
  }

  /// Adds an intermediate [state] to the [_ongoingDerivation] and save it.
  Future<void> addIntermediateStates(List<IntermediateDerivationStateEntity> states) async {
    if (_ongoingDerivation != null) {
      _ongoingDerivation!.intermediateDerivationStates.addAll(states);
    }
    await writeProfile();
  }

  /// Clears the ongoing derivation.
  Future<void> clearOngoingDerivation() async {
    _ongoingDerivation = null;
    await writeProfile();
  }

  Set<MemoCard> get memoCards => Set.unmodifiable(_memoCards);

   OngoingDerivationEntity? get ongoingDerivation => _ongoingDerivation;

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
