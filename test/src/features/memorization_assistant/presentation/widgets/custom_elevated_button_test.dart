import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:t3_vault/src/features/memorization_assistant/presentation/widgets/custom_elevated_button.dart';

void main() {
  testWidgets('CustomElevatedButton displays text correctly', (WidgetTester tester) async {
    // Arrange
    const buttonText = 'Submit';

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomElevatedButton(
            text: buttonText,
            onPressed: () {
            },
          ),
        ),
      ),
    );

    // Assert
    expect(find.text(buttonText), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('CustomElevatedButton calls onPressed when tapped', (WidgetTester tester) async {
    // Arrange
    bool buttonPressed = false;

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomElevatedButton(
            text: 'Tap Me',
            onPressed: () {
              buttonPressed = true;
            },
          ),
        ),
      ),
    );

    final buttonFinder = find.byType(CustomElevatedButton);
    expect(buttonFinder, findsOneWidget);
    await tester.tap(buttonFinder);
    await tester.pump();

    // Assert
    expect(buttonPressed, isTrue);
  });

  testWidgets('CustomElevatedButton has correct background color', (WidgetTester tester) async {
    // Arrange
    const buttonText = 'Test Color';

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomElevatedButton(
            text: buttonText,
            onPressed: () {},
          ),
        ),
      ),
    );

    // Assert
    final buttonFinder = find.byType(ElevatedButton);
    expect(buttonFinder, findsOneWidget);

    final ElevatedButton button = tester.widget(buttonFinder);
    final WidgetStateProperty<Color?>? backgroundColor = button.style?.backgroundColor;

    final color = backgroundColor?.resolve({WidgetState.pressed});
    expect(color, const Color(0xFF70A8FF));
  });
}
