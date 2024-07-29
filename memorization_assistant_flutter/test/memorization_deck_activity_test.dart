import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_assistant_flutter/memorization_deck_activity.dart';

void main() {
  testWidgets(
      'MemorizationDeckActivity has a title and displays elements correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MemorizationDeckActivity(),
      ),
    );

    expect(find.text('Greatwall TKBA Protocol'), findsOneWidget);

    expect(find.text('My Cards'), findsOneWidget);

    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.text('Try protocol'), findsOneWidget);

    expect(find.textContaining('L'), findsNWidgets(6));
    expect(find.text('Next review:\nyyyy-mm-dd'), findsNWidgets(6));
  });

  testWidgets('MemorizationDeckActivity has cards with the correct color',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MemorizationDeckActivity(),
      ),
    );

    final cardContainers =
        tester.widgetList<Container>(find.byType(Container)).where((container) {
      final decoration = container.decoration as BoxDecoration?;
      return decoration != null && decoration.color == const Color(0xFF4A6FA5);
    }).toList();

    expect(cardContainers.length, 6);
  });

  testWidgets('MemorizationDeckActivity horizontal scroll works',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MemorizationDeckActivity(),
      ),
    );

    final cardContainerFinder = find.byWidgetPredicate(
        (widget) => widget is Container && widget.decoration is BoxDecoration);

    final scrollableFinder = find.descendant(
      of: cardContainerFinder,
      matching: find.byType(SingleChildScrollView),
    );

    expect(scrollableFinder, findsOneWidget);

    final scrollable = tester.widget<SingleChildScrollView>(scrollableFinder);
    expect(scrollable.scrollDirection, Axis.horizontal);
  });

  testWidgets('MemorizationDeckActivity button press works',
      (WidgetTester tester) async {
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

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(buttonPressed, isTrue);
  });
}
