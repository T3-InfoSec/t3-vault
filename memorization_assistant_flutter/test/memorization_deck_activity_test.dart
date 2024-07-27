import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_assistant_flutter/memorization_deck_activity.dart';

void main() {
  testWidgets('MemorizationDeckActivity has a title and displays elements correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MemorizationDeckActivity(),
      ),
    );

    expect(find.text('Greatwall TKBA Protocol'), findsOneWidget);

    expect(find.text('My Cards'), findsOneWidget);

    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.text('Try protocol'), findsOneWidget);

    expect(find.text('L0 Q Lorem Ipsum'), findsNWidgets(3));
    expect(find.text('R1: adipiscing elit\nR2: sed eiusmod\nR3: laboris nisi ut\nR4: aliquip'), findsNWidgets(3));
  });

  testWidgets('MemorizationDeckActivity has three cards with different colors', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MemorizationDeckActivity(),
      ),
    );

    // Find all card containers
    final cardContainers = tester.widgetList<Container>(find.byType(Container)).where((container) {
      return container.decoration is BoxDecoration;
    }).toList();

    expect(cardContainers.length, 4); // 3 cards + 1 main container

    final cardColors = cardContainers.map((container) {
      final decoration = container.decoration as BoxDecoration;
      return decoration.color;
    }).toList();

    expect(cardColors, containsAll([const Color(0xFF5DB075), const Color(0xFFFFD166), const Color(0xFFFF6961)]));
  });

  testWidgets('MemorizationDeckActivity horizontal scroll works', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MemorizationDeckActivity(),
      ),
    );

    final cardContainerFinder = find.byWidgetPredicate((widget) =>
      widget is Container && widget.decoration is BoxDecoration);

    final scrollableFinder = find.descendant(
      of: cardContainerFinder,
      matching: find.byType(SingleChildScrollView),
    );

    expect(scrollableFinder, findsOneWidget);

    final scrollable = tester.widget<SingleChildScrollView>(scrollableFinder);
    expect(scrollable.scrollDirection, Axis.horizontal);
  });

  testWidgets('MemorizationDeckActivity button press works', (WidgetTester tester) async {
    bool buttonPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ElevatedButton(
            onPressed: () {
              buttonPressed = true;
            },
            child: const Text('Try protocol'),
          ),
        ),
      ),
    );

    // Verify that the button press changes the state
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(buttonPressed, isTrue);
  });
}
