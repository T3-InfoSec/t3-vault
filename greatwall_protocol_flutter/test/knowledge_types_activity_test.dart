import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:greatwall_protocol_flutter/knowledge_types_activity.dart';

void main() {
  testWidgets('KnowledgeTypesActivity has the correct AppBar and buttons', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: KnowledgeTypesActivity(),
      ),
    );

    expect(find.text('Greatwall TKBA Protocol'), findsOneWidget);

    final List<String> knowledgeTypes = ["Hashviz", "Formosa", "Fractal", "Voice"];
    for (String type in knowledgeTypes) {
      expect(find.text(type), findsOneWidget);
    }

    final appBar = tester.widget<AppBar>(find.byType(AppBar));
    expect(appBar.backgroundColor, const Color(0xFF70A8FF));

    final buttonFinder = find.byType(ElevatedButton);
    for (final button in buttonFinder.evaluate()) {
      final elevatedButton = button.widget as ElevatedButton;
      final buttonColor = elevatedButton.style?.backgroundColor?.resolve({}) ?? Colors.transparent;

      expect(buttonColor, const Color(0xFF70A8FF));
    }
  });
}
