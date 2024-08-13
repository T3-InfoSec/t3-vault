import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:t3_vault/src/features/greatwall_derivation/presentation/pages/tree_input_parameters_page.dart';

import 'package:t3_vault/src/features/greatwall_derivation/presentation/widgets/custom_elevated_button_widget.dart';
import 'package:t3_vault/src/features/greatwall_derivation/presentation/widgets/custom_text_field_widget.dart';
import 'package:t3_vault/src/features/greatwall_derivation/presentation/widgets/password_text_field_widget.dart';
import 'package:t3_vault/src/features/greatwall_derivation/presentation/widgets/theme_dropdown_button_widget.dart';

void main() {
  testWidgets('Displays the correct title in AppBar', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: TreeInputsParametersPage(),
      ),
    );

    expect(find.text('Tree Input Parameters'), findsOneWidget);
  });

  testWidgets('Displays all widgets correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: TreeInputsParametersPage(),
      ),
    );

    expect(find.byType(ThemeDropdownButton), findsOneWidget);
    expect(find.byType(CustomTextField), findsNWidgets(3));
    expect(find.byType(PasswordTextField), findsOneWidget);
    expect(find.widgetWithText(CustomElevatedButton, 'Derive'), findsOneWidget);
  });

  testWidgets('Initial theme dropdown value is null', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: TreeInputsParametersPage(),
      ),
    );

    final themeDropdown = find.byType(ThemeDropdownButton).evaluate().single.widget as ThemeDropdownButton;
    expect(themeDropdown.selectedTheme, isNull);
  });

  testWidgets('Text fields have correct hint text', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: TreeInputsParametersPage(),
      ),
    );

    expect(find.widgetWithText(CustomTextField, 'Choose TLP'), findsOneWidget);
    expect(find.widgetWithText(CustomTextField, 'Choose tree depth'), findsOneWidget);
    expect(find.widgetWithText(CustomTextField, 'Choose tree arity'), findsOneWidget);
  });

  testWidgets('Derive button press does not crash', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: TreeInputsParametersPage(),
      ),
    );

    await tester.tap(find.widgetWithText(CustomElevatedButton, 'Derive'));
    await tester.pump();
    // No specific behavior to test, just ensuring no crash
  });
}
