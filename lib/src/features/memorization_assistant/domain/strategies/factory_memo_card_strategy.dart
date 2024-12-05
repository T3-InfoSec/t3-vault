import 'package:t3_memassist/memory_assistant.dart';
import 'package:t3_vault/src/features/memorization_assistant/domain/strategies/eka_memo_card_strategy.dart';
import 'package:t3_vault/src/features/memorization_assistant/domain/strategies/memo_card_strategy.dart';
import 'package:t3_vault/src/features/memorization_assistant/domain/strategies/pa0_memo_card_strategy.dart';
import 'package:t3_vault/src/features/memorization_assistant/domain/strategies/tacit_knowledge_strategy.dart';

class MemoCardStrategyFactory {
  static MemoCardStrategy getStrategy(MemoCard memoCard) {
    if (memoCard is TacitKnowledgeMemoCard) {
      return TacitKnowledgeStrategy();
    } else if (memoCard is Pa0MemoCard) {
      return Pa0MemoCardStrategy();
    } else if (memoCard is EkaMemoCard) {
      return EkaMemoCardStrategy();
    }
    throw UnsupportedError('Unsupported MemoCard type: ${memoCard.runtimeType}');
  }
}
