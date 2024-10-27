import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:t3_vault/src/features/memorization_assistant/domain/repositories/memo_card_json_repository.dart';

import 'src/app.dart';
import 'src/common/settings/domain/entities/settings_service.dart';
import 'src/common/settings/domain/usecases/settings_controller.dart';

void main() async {
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());
  
  // Get the application documents directory, which is a suitable location
  // to store user-specific documents and files for this application.
  final directory = await getApplicationDocumentsDirectory();

  // Create the full file path for the memo cards JSON file, ensuring that
  // it is stored within the application documents directory.
  final filePath = '${directory.path}/memo_cards.json';

  // Initialize the MemoCardRepository with the specified file path, allowing
  // the application to read and write memo card data to the JSON file.
  final memoCardRepository = MemoCardRepository(filePath: filePath);

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(T3Vault(
    settingsController: settingsController,
    memoCardRepository: memoCardRepository,)
  );
}
