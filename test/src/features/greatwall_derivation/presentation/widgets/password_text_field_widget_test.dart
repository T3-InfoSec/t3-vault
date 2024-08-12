import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:t3_vault/src/features/greatwall_derivation/presentation/widgets/password_text_field_widget.dart';

void main() {
  testWidgets('PasswordTextField displays correctly with default state',
      (WidgetTester tester) async {
    // Arrange
    final controller = TextEditingController();

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PasswordTextField(controller: controller),
        ),
      ),
    );

    // Assert
    final textFieldFinder = find.byType(TextField);
    expect(textFieldFinder, findsOneWidget);
    final containerFinder = find.byType(Container);
    expect(containerFinder, findsOneWidget);
    final containerWidget = tester.widget<Container>(containerFinder);
    expect(containerWidget.decoration, isA<BoxDecoration>());
    expect((containerWidget.decoration as BoxDecoration).color,
        const Color(0xFFD9D9D9));
    expect((containerWidget.decoration as BoxDecoration).borderRadius,
        BorderRadius.circular(25));
  });

  testWidgets('PasswordTextField accepts input text and updates the controller',
      (WidgetTester tester) async {
    // Arrange
    final controller = TextEditingController();

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PasswordTextField(controller: controller),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'test_password');

    // Assert
    expect(controller.text, 'test_password');
  });
}
