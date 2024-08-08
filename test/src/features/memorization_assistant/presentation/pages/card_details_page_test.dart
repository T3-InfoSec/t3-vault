import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:memory_assistant/memory_assistant.dart';

import 'package:t3_vault/src/features/memorization_assistant/presentation/pages/card_details_page.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/widgets/card_details_widget.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/widgets/custom_elevated_button.dart';

void main() {
  testWidgets('CardDetailsPage displays AppBar with correct title', (WidgetTester tester) async {
    // Arrange
    final testMemoCard = MemoCard();

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: CardDetailsPage(
          nodeNumber: 1,
          memoCard: testMemoCard,
        ),
      ),
    );

    // Assert
    expect(find.text('Greatwall TKBA Protocol'), findsOneWidget);
  });

  testWidgets('CardDetailsPage displays CardDetailsWidget correctly', (WidgetTester tester) async {
    // Arrange
    final testMemoCard = MemoCard();

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: CardDetailsPage(
          nodeNumber: 1,
          memoCard: testMemoCard,
        ),
      ),
    );

    // Assert
    expect(find.byType(CardDetailsWidget), findsOneWidget);
    expect(find.text('Memorization Card L1 Details'), findsOneWidget);
  });

  testWidgets('CardDetailsPage displays CustomElevatedButton with correct text', (WidgetTester tester) async {
    // Arrange
    final testMemoCard = MemoCard();

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: CardDetailsPage(
          nodeNumber: 1,
          memoCard: testMemoCard,
        ),
      ),
    );

    // Assert
    expect(find.byType(CustomElevatedButton), findsOneWidget);
    expect(find.text('Try protocol'), findsOneWidget);
  });

  testWidgets('CardDetailsPage calls onPressed when CustomElevatedButton is tapped', (WidgetTester tester) async {
    // Arrange
    final testMemoCard = MemoCard();

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CardDetailsPage(
            nodeNumber: 1,
            memoCard: testMemoCard,
          ),
        ),
      ),
    );

    final buttonFinder = find.byType(CustomElevatedButton);
    expect(buttonFinder, findsOneWidget);
    await tester.tap(buttonFinder);
    await tester.pump();

    // Assert
    // TODO: Test navigation to Greatwall protocol
  });
}
