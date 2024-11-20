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

  void clearPendingPayload() {
    _pendingPayload = null;
  }
}