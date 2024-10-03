import 'package:hive/hive.dart';

part 'hashviz_tacit_knowledge_entity.g.dart';

/// Database access object for Memorization Card
///
/// To generate the Hive adapter [TypeAdapterGenerator] from this [HashvizTacitKnowledgeEntity]
/// run the following command: `flutter packages pub run build_runner build`
@HiveType(typeId: 2) 
class HashvizTacitKnowledgeEntity extends HiveObject {
  @HiveField(0)
  Map<String, dynamic> configs;

  @HiveField(1)
  String? paramName;
  
  @HiveField(2)
  String? paramInitialState;

  @HiveField(3)
  String? paramAdjustmentValue;  
      
  HashvizTacitKnowledgeEntity({
    required this.configs,
    this.paramName,
    this.paramInitialState,
    this.paramAdjustmentValue,
  });
}
