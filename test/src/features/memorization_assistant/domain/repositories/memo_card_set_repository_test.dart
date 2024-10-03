import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:t3_memassist/memory_assistant.dart';
import 'package:t3_vault/src/features/memorization_assistant/domain/converters/memo_card_converter.dart';
import 'package:t3_vault/src/features/memorization_assistant/domain/entities/memo_card_entity.dart';
import 'package:t3_vault/src/features/memorization_assistant/domain/repositories/memo_card_set_repository.dart';

void main() {
  late MemoCardSetRepository repository;
  late Box<MemoCardEntity> box;

  setUp(() async {
    await setUpTestHive();

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(MemoCardEntityAdapter());
    }

    box = await Hive.openBox<MemoCardEntity>('testMemoCardSet');
    repository = MemoCardSetRepository(box);
  });

  tearDown(() async {
    if (box.isOpen) {
      await box.clear();
      await box.close();
    }

    await tearDownTestHive();
  });

  group('MemoCardSetRepository with Hive', () {
    test('should add a memo card', () async {
      final memoCard = MemoCard(knowledge: "test knowledge");
      await repository.addMemoCard(memoCard);

      expect(box.length, 1);
    });

    test('should get a set of memo cards', () async {
      final memoCard1 = MemoCard(knowledge: "test knowledge");
      final memoCard2 = MemoCard(knowledge: "test knowledge");

      await repository.addMemoCard(memoCard1);
      await repository.addMemoCard(memoCard2);

      final memoCards = await repository.getMemoCardSet();

      expect(memoCards.length, 2);
    });

    test('should remove a memo card', () async {
      final memoCard = MemoCard(knowledge: "test knowledge");
      await repository.addMemoCard(memoCard);

      final entities = box.values.toList();
      final entityToRemove = entities.firstWhere(
        (e) => MemoCardConverter.fromEntity(e).knowledge == memoCard.knowledge,
      );

      await box.delete(entityToRemove.key);

      expect(box.length, 0);
    });

    test('should clear the memo card set', () async {
      final memoCard1 = MemoCard(knowledge: "test knowledge");
      final memoCard2 = MemoCard(knowledge: "test knowledge");

      await repository.addMemoCard(memoCard1);
      await repository.addMemoCard(memoCard2);

      await repository.clearMemoCardSet();

      expect(box.length, 0);
    });
  });
}
