import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:t3_vault/src/features/greatwall_derivation/presentation/pages/derivation_level_page.dart';

void main() {
  group('DerivationLevelPage', () {
    testWidgets('should display the correct title, level text, and buttons', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: DerivationLevelPage(),
        ),
      );

      // Act
      final List<String> arityIndexes = [
        "moment weapon pact",
        "bone exact certain",
        "affair muffin display",
        "net cancel snack"
      ];

      // Assert
      expect(find.text('Greatwall TKBA Protocol'), findsOneWidget);
      expect(find.text('Level 0 of 1:'), findsOneWidget);
      for (final arityIndex in arityIndexes) {
        expect(find.text(arityIndex), findsOneWidget);
      }
    });

    testWidgets('should have correct background color and app bar color', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: DerivationLevelPage(),
        ),
      );

      // Act
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      final appBar = tester.widget<AppBar>(find.byType(AppBar));

      // Assert
      expect(scaffold.backgroundColor, Colors.white);
      expect(appBar.backgroundColor, const Color(0xFF70A8FF));
    });
  });
}
