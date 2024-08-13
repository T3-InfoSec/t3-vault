import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:t3_vault/src/features/greatwall_derivation/presentation/pages/knowledge_types_page.dart';

import 'package:t3_vault/src/features/greatwall_derivation/presentation/widgets/custom_elevated_button_widget.dart';

void main() {
  testWidgets('Displays the correct title in AppBar', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: KnowledgeTypesPage(),
      ),
    );

    expect(find.text('Greatwall TKBA Protocol'), findsOneWidget);
  });

  testWidgets('Displays all knowledge types as buttons', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: KnowledgeTypesPage(),
      ),
    );

    expect(find.widgetWithText(CustomElevatedButton, 'Hashviz'), findsOneWidget);
    expect(find.widgetWithText(CustomElevatedButton, 'Formosa'), findsOneWidget);
    expect(find.widgetWithText(CustomElevatedButton, 'Fractal'), findsOneWidget);
    expect(find.widgetWithText(CustomElevatedButton, 'Voice'), findsOneWidget);
  });
}
