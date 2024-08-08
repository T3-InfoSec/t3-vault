import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:t3_vault/src/features/memorization_assistant/presentation/pages/card_details_page.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/pages/memorization_assistant_deck_page.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/widgets/custom_elevated_button.dart';

void main() {
  testWidgets('MemorizationDeckPage displays AppBar with correct title', (WidgetTester tester) async {
    // Act
    await tester.pumpWidget(
      const MaterialApp(
        home: MemorizationDeckPage(),
      ),
    );

    // Assert
    expect(find.text('Greatwall TKBA Protocol'), findsOneWidget);
  });

  testWidgets('MemorizationDeckPage displays cards and navigates to CardDetailsPage on tap', (WidgetTester tester) async {
    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: const MemorizationDeckPage(),
        onGenerateRoute: (settings) {
          if (settings.name == '/cardDetails') {
            final args = settings.arguments as Map;
            return MaterialPageRoute(
              builder: (context) => CardDetailsPage(
                nodeNumber: args['nodeNumber'],
                memoCard: args['memoCard'],
              ),
            );
          }
          return null;
        },
      ),
    );

    // Assert
    expect(find.byType(GestureDetector), findsNWidgets(10));

    await tester.tap(find.byType(GestureDetector).first);
    await tester.pumpAndSettle();

    expect(find.byType(CardDetailsPage), findsOneWidget);
  });

  testWidgets('MemorizationDeckPage displays CustomElevatedButton with correct text', (WidgetTester tester) async {
    // Act
    await tester.pumpWidget(
      const MaterialApp(
        home: MemorizationDeckPage(),
      ),
    );

    // Assert
    expect(find.byType(CustomElevatedButton), findsOneWidget);
    expect(find.text('Try protocol'), findsOneWidget);
  });

  testWidgets('CustomElevatedButton triggers action when pressed', (WidgetTester tester) async {
    // Arrange

    // Act
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MemorizationDeckPage(),
        ),
      ),
    );

    // Assert
    final buttonFinder = find.byType(CustomElevatedButton);
    expect(buttonFinder, findsOneWidget);

    await tester.tap(buttonFinder);
    await tester.pump(); 

    // TODO: Implement navigation to greatwall protocol
  });
}
