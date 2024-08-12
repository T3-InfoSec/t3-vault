import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:t3_vault/src/features/greatwall_derivation/presentation/widgets/theme_dropdown_button_widget.dart';

void main() {
  group('ThemeDropdownButton', () {
    testWidgets('displays the correct hint text when no theme is selected', (WidgetTester tester) async {
      // Arrange
      const String hintText = 'Choose Theme';
      const List<String> themes = ['Theme1', 'Theme2', 'Theme3'];
      
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ThemeDropdownButton(
              selectedTheme: null,
              themes: themes,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(hintText), findsOneWidget);
    });

    testWidgets('displays the selected theme when a theme is chosen', (WidgetTester tester) async {
      // Arrange
      const String selectedTheme = 'Theme1';
      const List<String> themes = ['Theme1', 'Theme2', 'Theme3'];
      
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ThemeDropdownButton(
              selectedTheme: selectedTheme,
              themes: themes,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(selectedTheme), findsOneWidget);
    });

    testWidgets('calls onChanged when a theme is selected', (WidgetTester tester) async {
      // Arrange
      String? selectedTheme;
      const List<String> themes = ['Theme1', 'Theme2', 'Theme3'];

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ThemeDropdownButton(
              selectedTheme: selectedTheme,
              themes: themes,
              onChanged: (String? value) {
                selectedTheme = value;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.arrow_downward));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Theme2').last);
      await tester.pumpAndSettle();

      // Assert
      expect(selectedTheme, equals('Theme2'));
    });

    testWidgets('displays all provided themes as dropdown items', (WidgetTester tester) async {
      // Arrange
      const List<String> themes = ['Theme1', 'Theme2', 'Theme3'];
      
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ThemeDropdownButton(
              selectedTheme: null,
              themes: themes,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.arrow_downward));
      await tester.pumpAndSettle();

      // Assert
      for (var theme in themes) {
        expect(find.text(theme), findsOneWidget);
      }
    });
  });
}
