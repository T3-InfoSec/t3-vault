import 'package:t3_vault/src/features/memorization_assistant/domain/converters/memo_card_json_converter.dart';
import 'package:t3_vault/src/features/memorization_assistant/domain/models/profile_model.dart';
import 'package:uuid/uuid.dart';

class ProfileJsonConverter {
  static const _uuid = Uuid();

  /// Converts a Profile object to JSON format.
  static Map<String, dynamic> toJson(Profile profile) {
    final memoCard = profile.memoCard;
    final seedPA0 = profile.seedPA0;

    return {
      'memoCard': MemoCardConverter.toJson(memoCard),
      'seedPA0': seedPA0,
    };
  }

  /// Converts JSON to a Profile object.
  static Profile fromJson(Map<String, dynamic> json) {
    final memoCard = json['memoCard'];
    final seedPA0 = json['seedPA0'];

    return Profile(memoCard: MemoCardConverter.fromJson(memoCard), seedPA0: seedPA0);
  }

  /// Returns a newly generated UUID as a string.
  static String generateId() {
    return _uuid.v4();
  }
}
