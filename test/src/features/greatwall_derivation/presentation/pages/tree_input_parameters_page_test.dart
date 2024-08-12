import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:t3_vault/src/features/greatwall_derivation/presentation/pages/tree_input_parameters_page.dart';
import 'package:t3_vault/src/features/greatwall_derivation/presentation/widgets/password_text_field_widget.dart';
import 'package:t3_vault/src/features/greatwall_derivation/presentation/widgets/theme_dropdown_button_widget.dart';

void main() {
  group('TreeInputsParametersPage', () {
    testWidgets('displays all elements correctly', (WidgetTester tester) async {
      // Arrange

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: TreeInputsParametersPage(),
        ),
      );

      // Assert
      expect(find.byType(ThemeDropdownButton), findsOneWidget);
      expect(find.text('Choose TLP'), findsOneWidget);
      expect(find.text('Choose tree depth'), findsOneWidget);
      expect(find.text('Choose tree arity'), findsOneWidget);
      expect(find.byType(PasswordTextField), findsOneWidget);
      expect(find.text('Derive'), findsOneWidget);
    });

    testWidgets('allows selecting a theme from the dropdown', (WidgetTester tester) async {
      // Arrange

      await tester.pumpWidget(
        const MaterialApp(
          home: TreeInputsParametersPage(),
        ),
      );

      // Act
      await tester.tap(find.byIcon(Icons.arrow_downward));
      await tester.pumpAndSettle();
      await tester.tap(find.text('medieval fantasy').last);
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('medieval fantasy'), findsOneWidget);
    });

    testWidgets('allows entering text in the password field', (WidgetTester tester) async {
      // Arrange

      await tester.pumpWidget(
        const MaterialApp(
          home: TreeInputsParametersPage(),
        ),
      );

      // Act
      await tester.enterText(find.byType(PasswordTextField), 'secure_password');
      
      // Assert
      expect(find.text('secure_password'), findsOneWidget);
    });

    testWidgets('triggers onPressed callbacks for buttons', (WidgetTester tester) async {
      // Arrange
      bool chooseTLPButtonPressed = false;
      bool chooseTreeDepthButtonPressed = false;
      bool chooseTreeArityButtonPressed = false;
      bool deriveButtonPressed = false;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TreeInputsParametersPage(),
          ),
        ),
      );

      // Replace the default callbacks with our test callbacks
      await tester.tap(find.text('Choose TLP'));
      await tester.tap(find.text('Choose tree depth'));
      await tester.tap(find.text('Choose tree arity'));
      await tester.tap(find.text('Derive'));

      // Assert
      expect(chooseTLPButtonPressed, isTrue);
      expect(chooseTreeDepthButtonPressed, isTrue);
      expect(chooseTreeArityButtonPressed, isTrue);
      expect(deriveButtonPressed, isTrue);
    });
  });
}
