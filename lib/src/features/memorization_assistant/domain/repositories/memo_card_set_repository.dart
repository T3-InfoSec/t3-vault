import 'package:hive/hive.dart';
import 'package:t3_memassist/memory_assistant.dart';
import 'package:t3_vault/src/features/memorization_assistant/domain/entities/memo_card_converter.dart';
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

  MemoCardSetRepository(this.box);

  Future<void> addMemoCard(MemoCard memoCard) async {
    final memoCardEntity = MemoCardConverter.toEntity(memoCard);
    await box.add(memoCardEntity);
  }

  Future<List<MemoCard>> getMemoCardSet() async {
    final memoCardEntities = box.values.toList();
    return memoCardEntities.map((e) => MemoCardConverter.fromEntity(e)).toList();
  }

  Future<void> removeMemoCard(MemoCard memoCard) async {
    final memoCardEntity = MemoCardConverter.toEntity(memoCard);
    await box.delete(memoCardEntity.key);
  }

  Future<void> clearMemoCardSet() async {
    await box.clear();
  }
}
