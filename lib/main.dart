import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:t3_vault/src/common/localization/timezone/timezone_helper.dart';
import 'package:t3_vault/src/common/notifications/domain/notifications_service.dart';
import 'package:t3_vault/src/common/notifications/state/notifications_state.dart';
import 'package:t3_vault/src/features/greatwall/states/derivation_state.dart';
import 'package:t3_vault/src/features/memorization_assistant/domain/repositories/profile_json_repository.dart';

import 'src/app.dart';
import 'src/common/settings/domain/entities/settings_service.dart';
import 'src/common/settings/domain/usecases/settings_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Initialize the TimeZoneHelper, which ensures proper handling of time zones
  // for features such as scheduling notifications.
  await TimeZoneHelper.initialize();

  // Set up the NotificationService and request permissions needed to display
  // notifications on supported platforms.
  final notificationService = NotificationService();
  final notificationsState = NotificationsState();
  notificationService.setNotificationsState(notificationsState);
  await notificationService.requestPermissions();

  // Get the application documents directory, which is a suitable location
  // to store user-specific documents and files for this application.
  final directory = await getApplicationDocumentsDirectory();

  // Create the full file path for the memo cards JSON file, ensuring that
  // it is stored within the application documents directory.
  final filePath = '${directory.path}/t3-profiles.json';

  // Initialize the ProfileRepository with the specified file path, allowing
  // the application to read and write data to the JSON file.
  final profileRepository = ProfileRepository(
      filePath: filePath, notificationService: notificationService);

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => DerivationState()),
          ChangeNotifierProvider.value(value: notificationsState),
        ],
        child: T3Vault(
          settingsController: settingsController,
          profileRepository: profileRepository,
        )),
  );
}
