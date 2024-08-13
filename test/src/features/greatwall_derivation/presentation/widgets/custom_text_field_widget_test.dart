import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:t3_vault/src/features/greatwall_derivation/presentation/widgets/custom_text_field_widget.dart';

void main() {
  testWidgets('CustomTextField displays hint text and accepts input', (WidgetTester tester) async {
    final controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomTextField(
            hintText: 'Enter text',
            controller: controller,
          ),
        ),
      ),
    );

    expect(find.text('Enter text'), findsOneWidget);

    final textFieldFinder = find.byType(TextField);
    expect(textFieldFinder, findsOneWidget);

    await tester.enterText(textFieldFinder, 'Test input');
    expect(controller.text, 'Test input');
  });

  testWidgets('CustomTextField has correct hint text style', (WidgetTester tester) async {
    final controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomTextField(
            hintText: 'Hint text',
            controller: controller,
          ),
        ),
      ),
    );

    final hintFinder = find.text('Hint text');
    expect(hintFinder, findsOneWidget);

    final textField = tester.widget<TextField>(find.byType(TextField));
    final hintStyle = textField.decoration?.hintStyle;
    expect(hintStyle?.color, Colors.black);
  });

  testWidgets('CustomTextField has correct border colors', (WidgetTester tester) async {
    final controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomTextField(
            hintText: 'Border test',
            controller: controller,
          ),
        ),
      ),
    );

    final textFieldFinder = find.byType(TextField);
    final textField = tester.widget<TextField>(textFieldFinder);

    final enabledBorder = textField.decoration?.enabledBorder as UnderlineInputBorder?;
    final focusedBorder = textField.decoration?.focusedBorder as UnderlineInputBorder?;

    expect(enabledBorder?.borderSide.color, Colors.blue);
    expect(focusedBorder?.borderSide.color, const Color(0xFF70A8FF));
  });
}
