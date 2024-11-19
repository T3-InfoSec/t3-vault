import 'package:flutter/material.dart';

class NotificationsState extends ChangeNotifier {
  String? _pendingPayload;

  String? get pendingPayload => _pendingPayload;

  void handleNotificationTap(String payload) {
    _pendingPayload = payload;
    notifyListeners(); // TODO: Hanlde notificaions in HomePage, MemoCardsPage, NotificationsPage
  }

  void clearPendingPayload() {
    _pendingPayload = null;
  }
}