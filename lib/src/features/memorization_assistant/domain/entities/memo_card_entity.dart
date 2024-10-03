import 'package:hive/hive.dart';

part 'memo_card_entity.g.dart';

/// Database access object for Memorization Card
///
/// To generate the Hive adapter [TypeAdapterGenerator] from this [MemoCardEntity]
/// run the following command: `flutter packages pub run build_runner build`
@HiveType(typeId: 0)
class MemoCardEntity extends HiveObject {
  @HiveField(0)
  final dynamic knowledge;

  @HiveField(1)
  final DateTime due;

  @HiveField(2)
  final DateTime lastReview;

  @HiveField(3)
  final double stability;

  @HiveField(4)
  final double difficulty;

  @HiveField(5)
  final int elapsedDays;

  @HiveField(6)
  final int scheduledDays;

  @HiveField(7)
  final int reps;

  @HiveField(8)
  final int lapses;

  @HiveField(9)
  final int stateIndex;

  MemoCardEntity({
    required this.knowledge,
    required this.due,
    required this.lastReview,
    required this.stability,
    required this.difficulty,
    required this.elapsedDays,
    required this.scheduledDays,
    required this.reps,
    required this.lapses,
    required this.stateIndex,
  });
}
