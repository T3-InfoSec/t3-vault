import 'dart:convert';

import 'package:flutter/material.dart';

class NotificationsState extends ChangeNotifier {
  String? _pendingPayload;

  String? get pendingPayload {
    return _pendingPayload;
  }

  void handleNotificationTap(String payload) {
    _pendingPayload = payload;
    notifyListeners(); // TODO: Hanlde notificaions in MemoCardsPage
  }

  static String? extractDeckIdFromPayload(String payload) {
    try {
      final decodedPayload = jsonDecode(payload) as Map<String, dynamic>;
      return decodedPayload['deckId'] as String?;
    } catch (e) {
      debugPrint('Error decoding payload: $e');
      return null;
    }
  }

  static String? extractMemoCardIdFromPayload(String payload) {
    try {
      final decodedPayload = jsonDecode(payload) as Map<String, dynamic>;
      return decodedPayload['id'] as String?;
    } catch (e) {
      debugPrint('Error decoding payload: $e');
      return null;
    }
  }

  void clearPendingPayload() {
    _pendingPayload = null;
    notifyListeners();
  }
}