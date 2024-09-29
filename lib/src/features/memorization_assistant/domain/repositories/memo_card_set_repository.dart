import 'package:hive/hive.dart';
import 'package:t3_memassist/memory_assistant.dart';
import 'package:t3_vault/src/features/memorization_assistant/domain/entities/memo_card_converter.dart';
import 'package:t3_vault/src/features/memorization_assistant/domain/entities/memo_card_entity.dart';

class MemoCardSetRepository {
  static const String boxName = 'memoCardSet';

  Future<void> addMemoCard(MemoCard memoCard) async {
    final box = await Hive.openBox<MemoCardEntity>(boxName);
    final memoCardEntity = MemoCardConverter.toEntity(memoCard);
    await box.add(memoCardEntity);
  }

  Future<List<MemoCard>> getMemoCardSet() async {
    final box = await Hive.openBox<MemoCardEntity>(boxName);
    final memoCardEntities = box.values.toList();
    return memoCardEntities.map((e) => MemoCardConverter.fromEntity(e)).toList();
  }

  Future<void> removeMemoCard(MemoCard memoCard) async {
    final box = await Hive.openBox<MemoCardEntity>(boxName);
    final memoCardEntity = MemoCardConverter.toEntity(memoCard);
    await box.delete(memoCardEntity.key);
  }

  Future<void> clearMemoCardSet() async {
    final box = await Hive.openBox<MemoCardEntity>(boxName);
    await box.clear();
  }
}
