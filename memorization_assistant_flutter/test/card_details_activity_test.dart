import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:memorization_assistant_flutter/card_details_activity.dart';
import 'package:memory_assistant/memory_assistant.dart';

void main() {
  late MemoCard testMemoCard;

  setUp(() {
    testMemoCard = MemoCard({
      "firstLevel": ["testHash1"],
      "secondLevel": {"option1": ["testHash2"], "option2": ["testHash3"]}
    });
  });

  testWidgets('CardDetailsActivity UI test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: CardDetailsActivity(
        nodeNumber: 1,
        memoCard: testMemoCard,
      ),
    ));

    expect(find.text('Greatwall TKBA Protocol'), findsOneWidget);

    expect(find.text('Memorization Card L1 Details'), findsOneWidget);
    expect(find.text('State: ${testMemoCard.state}'), findsOneWidget);
    expect(find.textContaining('Due: '), findsOneWidget);
  });

  testWidgets('Try protocol button is present and clickable', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: CardDetailsActivity(
        nodeNumber: 1,
        memoCard: testMemoCard,
      ),
    ));

    final tryProtocolButtonFinder = find.text('Try protocol');
    expect(tryProtocolButtonFinder, findsOneWidget);

    await tester.tap(tryProtocolButtonFinder);
    await tester.pump();
  });

    testWidgets('Try protocol button has the correct color', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: CardDetailsActivity(
          nodeNumber: 1,
          memoCard: testMemoCard,
        ),
      ));

      final tryProtocolButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(tryProtocolButton.style?.backgroundColor?.resolve({}), const Color(0xFF70A8FF));
    });
}
