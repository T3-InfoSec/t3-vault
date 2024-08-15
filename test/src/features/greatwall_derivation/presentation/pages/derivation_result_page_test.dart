import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:t3_vault/src/features/greatwall_derivation/presentation/pages/derivation_result_page.dart';
import 'package:t3_vault/src/features/greatwall_derivation/presentation/widgets/password_text_field_widget.dart';

void main() {
  testWidgets('should display the correct title and KA Result text', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(const MaterialApp(home: DerivationResultPage()));

    // Act
    final titleFinder = find.text('Derivation finished');
    final kaResultTextFinder = find.text('KA Result:');
    final passwordTextFieldFinder = find.byType(PasswordTextField);
    final resetButtonFinder = find.text('Reset');

    // Assert
    expect(titleFinder, findsOneWidget);
    expect(kaResultTextFinder, findsOneWidget);
    expect(passwordTextFieldFinder, findsOneWidget);
    expect(resetButtonFinder, findsOneWidget);
  });
}
