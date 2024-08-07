import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:greatwall_protocol_flutter/secure_configurations_activity.dart';
import 'package:greatwall_protocol_flutter/knowledge_types_activity.dart';

void main() {
  testWidgets('Switch widget colors', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SecureConfigActivity()));

    final switchWidget = find.byType(Switch);
    final switchState = tester.widget<Switch>(switchWidget);
    expect(switchState.activeColor, const Color(0xFF70A8FF));
    expect(switchState.inactiveThumbColor, Colors.grey);
  });

  testWidgets('TextField color and dimensions', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SecureConfigActivity()));

    final containerFinder = find.byType(Container).first;
    final containerWidget = tester.widget<Container>(containerFinder);
    final boxDecoration = containerWidget.decoration as BoxDecoration;

    expect(boxDecoration.color, const Color(0xFFD9D9D9));
    expect(containerWidget.constraints?.minWidth, 306);
    expect(containerWidget.constraints?.minHeight, 130);
  });

  testWidgets('Check password button color and dimensions', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SecureConfigActivity()));

    final checkPasswordButtonFinder = find.byWidgetPredicate(
      (widget) => widget is ElevatedButton && widget.child is Text && (widget.child as Text).data == 'Check password',
    );
    final checkPasswordButtonWidget = tester.widget<ElevatedButton>(checkPasswordButtonFinder);
    final backgroundColor = checkPasswordButtonWidget.style?.backgroundColor?.resolve({}) as Color;

    expect(backgroundColor, const Color(0xFF70A8FF));

    final checkPasswordButtonSizedBox = find.byWidgetPredicate(
      (widget) => widget is SizedBox && widget.width == 306 && widget.height == 50,
    );
    expect(checkPasswordButtonSizedBox, findsOneWidget);
  });

  testWidgets('Correct button color and dimensions', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SecureConfigActivity()));

    final correctButtonFinder = find.byWidgetPredicate(
      (widget) => widget is ElevatedButton && widget.child is Text && (widget.child as Text).data == 'Correct',
    );
    final correctButtonWidget = tester.widget<ElevatedButton>(correctButtonFinder);
    final backgroundColor = correctButtonWidget.style?.backgroundColor?.resolve({}) as Color;

    expect(backgroundColor, const Color(0xFF70A8FF));

    final correctButtonSizedBox = find.byWidgetPredicate(
      (widget) => widget is SizedBox && widget.width == 250 && widget.height == 50,
    );
    expect(correctButtonSizedBox, findsOneWidget);
  });

  testWidgets('Check password button shows dialog with incorrect password', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SecureConfigActivity()));

    await tester.enterText(find.byType(TextField), 'wrongpassword');
    await tester.tap(find.byWidgetPredicate(
      (widget) => widget is ElevatedButton && widget.child is Text && (widget.child as Text).data == 'Check password',
    ));
    await tester.pump();

    expect(find.text('Password is incorrect!'), findsOneWidget);

    await tester.tap(find.text('OK'));
    await tester.pump();
  });

  testWidgets('Check password button shows dialog with correct password', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SecureConfigActivity()));

    await tester.enterText(find.byType(TextField), 'password');
    await tester.tap(find.byWidgetPredicate(
      (widget) => widget is ElevatedButton && widget.child is Text && (widget.child as Text).data == 'Check password',
    ));
    await tester.pump();

    expect(find.text('Password is correct!'), findsOneWidget);

    await tester.tap(find.text('OK'));
    await tester.pump();
  });

  testWidgets('Correct button navigates to KnowledgeTypesActivity', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SecureConfigActivity()));

    await tester.tap(find.byWidgetPredicate(
      (widget) => widget is ElevatedButton && widget.child is Text && (widget.child as Text).data == 'Correct',
    ));
    await tester.pumpAndSettle();

    expect(find.byType(KnowledgeTypesActivity), findsOneWidget);
  });
}
