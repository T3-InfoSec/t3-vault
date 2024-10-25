import 'dart:convert';
import 'dart:io';

import 'package:t3_memassist/memory_assistant.dart';
import 'package:t3_vault/src/features/memorization_assistant/domain/converters/profile_json_converter.dart';
import 'package:t3_vault/src/features/memorization_assistant/domain/models/profile_model.dart';

class ProfileRepository {
  final String filePath;
  Map<String, Profile> _profileIdMap = {};

  ProfileRepository({required this.filePath});

  /// Reads profiles from a JSON file and returns a map of profiles.
  ///
  /// This method attempts to read a JSON file located at [filePath]. If the file
  /// does not exist, it returns an empty map. The contents of the file are 
  /// expected to be a list of JSON objects representing memo cards.
  ///
  /// Each JSON object is converted to a [Profile] instance using 
  /// [ProfileJsonConverter.fromJson], and a corresponding ID is extracted from 
  /// the JSON object to serve as the key in the resulting map.
  Future<List> readProfiles() async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return [];
      }
      final contents = await file.readAsString();
      final profilesJson = jsonDecode(contents) as List;

      for (var profileJson in profilesJson) {
        final profile = ProfileJsonConverter.fromJson(profileJson);
        final id = profileJson['id'];
        _profileIdMap[id] = profile;
      }
      return _profileIdMap.values.toList();
    } catch (e) {
      // TODO: Handle file read errors
      return [];
    }
  }

  /// Adds a new profile to the repository.
  ///
  /// This method generates a unique ID for the provided [profile] and adds 
  /// it to the internal map [_profileIdMap]. The updated map is then written 
  /// to the JSON file located at [filePath] using [_writeProfiles] method.
  Future<void> addMemoCard(Profile profile) async {
    final id = ProfileJsonConverter.generateId();
    _profileIdMap[id] = profile;
    
    await _writeProfiles();
  }

  /// Removes a profile containing the specified memo card.
  ///
  /// This method identifies the ID of the profile from 
  /// [_profileIdMap] tha contains the given [memoCard] and removes the profile from the map.
  /// After removal, the updated map is saved to the JSON file at [filePath] 
  /// using the [_writeProfiles] method.
  Future<void> removeMemoCard(MemoCard memoCard) async {
    final id = _getProfileIdByMemoCard(memoCard);
    if (id != null) {
      _profileIdMap.remove(id);
    }
    
    await _writeProfiles();
  }

  /// Updates an existing profile containing the specified memo card.
  ///
  /// This method locates the ID of profile from [_profileIdMap] tha contains the given [memoCard]
  /// and updates its content.
  /// The updated map is saved to the JSON file at [filePath] using the [_writeProfiles] method.
  Future<void> updateMemoCard(MemoCard memoCard) async {
    final id = _getProfileIdByMemoCard(memoCard);
    if (id != null) {
      var profile = _profileIdMap[id];
      profile!.memoCard = memoCard;
      _profileIdMap[id] = profile;
    }

    await _writeProfiles();
  }

  /// Writes the current state of profiles to the JSON file.
  ///
  /// This private method converts the current entries in [_profileIdMap] 
  /// to JSON format using [ProfileJsonConverter.toJson], adds their corresponding 
  /// IDs, and writes the resulting list to the file located at [filePath].
  ///
  /// If the file does not exist, it will be created.  
  Future<void> _writeProfiles() async {
    final file = File(filePath);
    final jsonData = _profileIdMap.entries.map((entry) => {
      ...ProfileJsonConverter.toJson(entry.value),
      'id': entry.key,
    }).toList();
    await file.writeAsString(jsonEncode(jsonData));
  }

  Map<String, Profile> get profileIdMap => _profileIdMap;

  /// Retrieves the ID of a profile.
  ///
  /// This private method searches [_profileIdMap] for the provided [memoCard] 
  /// and returns its corresponding ID. If the memo card is not found, the method 
  /// returns `null`.
  String? _getProfileIdByMemoCard(MemoCard memoCard) {
    return _profileIdMap.entries.firstWhere((entry) => entry.value.memoCard == memoCard).key;
  }
}
