import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t3_vault/src/common/notifications/state/notifications_state.dart';

/// Displays the notifications section where users can manage notifications.
///
/// This page listens to the NotificationsState and displays a simple message
/// that can be expanded to show more notification-related content.
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  static const routeName = 'notifications';

  @override
  Widget build(BuildContext context) {
    // Listen to the NotificationsState using the provider
    final notificationState = Provider.of<NotificationsState>(context);
    final payload = notificationState.pendingPayload;

    // Handle pending notifications if any
    if (payload != null) {} // TODO: Handle notifications

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'), // TODO: softcode text
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text(
            'Notifications show here', // TODO: show notifications here.
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ),
    );
  }
}
