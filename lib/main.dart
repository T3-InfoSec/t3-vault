import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'src/app.dart';
import 'src/common/settings/domain/entities/settings_service.dart';
import 'src/common/settings/domain/usecases/settings_controller.dart';
import 'src/features/memorization_assistant/domain/entities/formosa_tacit_knowledge_entity.dart';
import 'src/features/memorization_assistant/domain/entities/hashviz_tacit_knowledge_entity.dart';
import 'src/features/memorization_assistant/domain/entities/memo_card_entity.dart';
import 'src/features/memorization_assistant/domain/repositories/memo_card_set_repository.dart';

void main() async {
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  var path = Directory.current.path; // TODO: Define directory for Hive database. 
  Hive
    ..init(path)
    ..registerAdapter(FormosaTacitKnowledgeEntityAdapter())
    ..registerAdapter(HashvizTacitKnowledgeEntityAdapter())
    ..registerAdapter(MemoCardEntityAdapter());

  final box = await Hive.openBox<MemoCardEntity>(MemoCardSetRepository.boxName);
  final memoCardSetRepository = MemoCardSetRepository(box);

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(T3Vault(
    settingsController: settingsController,
    memoCardSetRepository: memoCardSetRepository,
  ));
}
