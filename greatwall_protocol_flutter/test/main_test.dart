import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:greatwall_protocol_flutter/main.dart';

void main() {
  group('HomeScreen Tests', () {
    testWidgets('HomeScreen UI elements are displayed correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeActivity()));

      expect(find.text('Greatwall TKBA protocol'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
      expect(find.text('Deriving your hash'), findsOneWidget);
      expect(find.text('Practice on your derivation'), findsOneWidget);
    });

    testWidgets('Buttons have correct colors', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeActivity()));

      final deriveButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Deriving your hash'),
      );
      expect(deriveButton.style?.backgroundColor?.resolve({}), const Color(0xFF70A8FF));

      final practiceButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Practice on your derivation'),
      );
      expect(practiceButton.style?.backgroundColor?.resolve({}), const Color(0xFF70A8FF));
    });
  });
}
