import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:android_intent_plus/android_intent.dart';

import 'package:t3_vault/src/common/localization/timezone/timezone_helper.dart';
import 'package:t3_vault/src/common/notifications/state/notifications_state.dart';

/// Service for managing local notifications in the application.
///
/// This [NotificationService] provides a singleton implementation for managing notifications
/// across Android, iOS, macOS, and Linux platforms. It handles initialization,
/// permission requests, and scheduling of notifications.
class NotificationService {
  // Singleton instance
  static final NotificationService _instance = NotificationService._internal();

  /// Factory constructor to access the singleton instance.
  factory NotificationService() => _instance;

  bool _isInitialized = false;

  late NotificationsState? notificationsState;

  /// Internal instance of [FlutterLocalNotificationsPlugin] used for managing
  /// notifications on supported platforms.
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Private constructor to enforce singleton behavior.
  NotificationService._internal() {
    _initializePlugin();
  }

  void setNotificationsState(NotificationsState state) {
    notificationsState = state;
  }

  /// Initializes the notification plugin with platform-specific settings.
  ///
  /// This method configures initialization settings for Android, iOS, macOS,
  /// and Linux. It also defines a callback to handle user interactions with
  /// notifications.
  Future<void> _initializePlugin() async {
    if (_isInitialized) {
      if (notificationsState == null) {
        throw StateError(
            'NotificationsState must be set before initialization.');
      }
      return;
    }

    try {
      _isInitialized = true;

      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('app_icon');
      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings();
      const LinuxInitializationSettings linuxSettings =
          LinuxInitializationSettings(defaultActionName: 'Open');

      const InitializationSettings settings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
        linux: linuxSettings,
      );

      await _notificationsPlugin.initialize(
        settings,
        onDidReceiveNotificationResponse: (response) {
        notificationsState!.handleNotificationTap(response);
                },
      );
    } catch (e) {
      debugPrint('Error during initialization: $e');
      rethrow;
    }
  }

  /// Requests notification permissions from the user on iOS and macOS.
  ///
  /// This method requests permissions for displaying alerts, badges, and
  /// sounds. These permissions are not required on Android or Linux.
  Future<void> requestPermissions() async {
    if (Platform.isIOS) {
      await _requestIOSPermissions();
    } else if (Platform.isMacOS) {
      await _requestMacOSPermissions();
    } else if (Platform.isAndroid) {
      await _requestAndroidPermissions();
    }
  }

  /// Schedules a notification to be displayed at a specific date and time.
  ///
  /// The method supports immediate notifications for Linux (since zoned scheduling
  /// is not supported) and scheduled notifications for other platforms.
  ///
  /// [id] Unique identifier for the notification.
  /// [title] The title of the notification.
  /// [body] The body content of the notification.
  /// [scheduledDate] The date and time when the notification should be displayed.
  /// [payload] Additional data to be associated with the notification.
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    required String payload,
  }) async {
    if (Platform.isLinux) {
      // Linux does not support zonedSchedule. Immediate notification triggered.
      // TODO: use `flutter_desktop_notifications` to schedule linux notifications.
      await _notificationsPlugin.show(
        id,
        title,
        body,
        const NotificationDetails(
          linux: LinuxNotificationDetails(),
        ),
        payload: payload,
      );
    } else {
      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        TimeZoneHelper.toLocalTime(scheduledDate),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'memocard_review_channel',
            'Review MemoCard',
            channelDescription: 'Reminders to review your card',
          ),
          iOS: DarwinNotificationDetails(),
          // linux: LinuxNotificationDetails(),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    }
  }

  Future<void> _requestIOSPermissions() async {
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> _requestMacOSPermissions() async {
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> _requestAndroidPermissions() async {
    final hasPermission = await _checkAndroidExactAlarmsPermission();
    if (!hasPermission) {
      await _requestAndroidExactAlarmsPermission();
    }
  }

  Future<bool> _checkAndroidExactAlarmsPermission() async {
    return await _notificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.areNotificationsEnabled() ??
        false;
  }

  static Future<void> _requestAndroidExactAlarmsPermission() async {
    const intent = AndroidIntent(
      action: 'android.settings.APP_NOTIFICATION_SETTINGS',
      arguments: {
        'android.provider.extra.APP_PACKAGE': 'com.example.t3_vault',
      },
    );
    await intent.launch();
  }
}
