import 'package:hive/hive.dart';
import 'package:t3_memassist/memory_assistant.dart';
import 'package:t3_vault/src/features/memorization_assistant/domain/converters/memo_card_converter.dart';
import 'package:t3_vault/src/features/memorization_assistant/domain/entities/memo_card_entity.dart';

/// Repository for managing a set of memorization cards.
///
/// This class provides methods for adding, retrieving, removing, 
/// and clearing memorization cards in persistent storage using Hive. 
/// The `MemoCardSetRepository` is responsible for interacting with a 
/// Hive box to store and retrieve [MemoCardEntity] objects, which are 
/// converted from and to [MemoCard] objects using the [MemoCardConverter].
class MemoCardSetRepository {
  static const String boxName = 'memoCardSet';

  final Box<MemoCardEntity> box;
  final Map<MemoCard, dynamic> _memoCardKeyMap = {};

  MemoCardSetRepository(this.box);

  Future<void> addMemoCard(MemoCard memoCard) async {
    final memoCardEntity = MemoCardConverter.toEntity(memoCard);
    await box.add(memoCardEntity);
  }

  Future<List<MemoCard>> getMemoCardSet() async {
    final memoCardEntities = box.toMap();
    final memoCards = <MemoCard>[];

    memoCardEntities.forEach((key, entity) {
      final memoCard = MemoCardConverter.fromEntity(entity);
      memoCards.add(memoCard);
      _memoCardKeyMap[memoCard] = key;
    });

    return memoCards;
  }

  Future<void> removeMemoCard(MemoCard memoCard) async {
    final key = _memoCardKeyMap[memoCard];
    if (key != null) {
      await box.delete(key);
      _memoCardKeyMap.remove(memoCard);
    } // else {} TODO: Implement error handling
  }

  Future<void> clearMemoCardSet() async {
    await box.clear();
  }
}