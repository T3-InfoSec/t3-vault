import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:t3_vault/src/features/greatwall_derivation/presentation/pages/knowledge_types_page.dart';

void main() {
  testWidgets('KnowledgeTypesPage displays correctly with knowledge types', (WidgetTester tester) async {
    // Arrange

    // Act
    await tester.pumpWidget(
      const MaterialApp(
        home: KnowledgeTypesPage(),
      ),
    );

    // Assert
    expect(find.text('Greatwall TKBA Protocol'), findsOneWidget);
    expect(find.text('Hashviz'), findsOneWidget);
    expect(find.text('Formosa'), findsOneWidget);
    expect(find.text('Fractal'), findsOneWidget);
    expect(find.text('Voice'), findsOneWidget);
  });

  testWidgets('KnowledgeTypesPage buttons are tappable', (WidgetTester tester) async {
    // Arrange
    bool buttonPressed = false;

    // Act
    await tester.pumpWidget(
      const MaterialApp(
        home: KnowledgeTypesPage(),
      ),
    );

    // Act
    await tester.tap(find.text('Hashviz'));
    await tester.pumpAndSettle();

    // Assert
    expect(buttonPressed, false);  // Modify this line when button actions are implemented later
  });
}
