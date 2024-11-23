import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// State management class for handling notifications in the application.
///
/// This [NotificationsState] class is responsible for storing and managing the
/// notification history, as well as processing user interactions with notifications.
/// It exposes methods to handle notification taps and to clear notifications
/// based on their unique identifier.
class NotificationsState extends ChangeNotifier {
  final List<NotificationResponse> _notificationHistory = [];

  List<NotificationResponse> get notificationHistory {
    return _notificationHistory;
  }

  /// Handles the tap on a notification by adding it to the notification history.
  ///
  /// When a user taps on a [notification], this method is called to add the tapped
  /// notification to the history and notify listeners to trigger any updates.
  void handleNotificationTap(NotificationResponse notification) {
   _notificationHistory.add(notification);
    notifyListeners();
  }

  /// Clears a notification from the history by its unique identifier.
  ///
  /// This method tries to find the notification with the specified [id] in the history
  /// and removes it. If the notification is not found, it logs an error message.
  void clearNotificationById(int id) {
    final NotificationResponse response;
    try {
    response = _notificationHistory.firstWhere(
      (response) => response.id == id);
    } catch (e) {
      debugPrint('Error clearing notification by id: $e');
      rethrow;
    }

    _notificationHistory.remove(response);
    notifyListeners();
  }
}