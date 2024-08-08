import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_assistant/memory_assistant.dart'; // Importar la clase MemoCard real
import 'package:t3_vault/src/features/memorization_assistant/presentation/widgets/card_details_widget.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/utils/memo_card_utils.dart';

void main() {
  testWidgets('CardDetailsWidget displays card details correctly', (WidgetTester tester) async {
    // Arrange
    final testMemoCard = MemoCard();

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CardDetailsWidget(
            nodeNumber: 1,
            memoCard: testMemoCard,
          ),
        ),
      ),
    );

    // Assert
    final formattedDueDate = MemoCardUtils.formatDueDate(testMemoCard.due);

    expect(find.text('Memorization Card L1 Details'), findsOneWidget);
    expect(find.text('State: ${MemoCardUtils.mapStatusToLabel(0)}'), findsOneWidget);
    expect(find.text('Due: $formattedDueDate'), findsOneWidget);
  });
}
