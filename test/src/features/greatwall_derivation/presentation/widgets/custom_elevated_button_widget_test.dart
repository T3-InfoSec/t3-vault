import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:t3_vault/src/features/greatwall_derivation/presentation/widgets/toggle_switch_widget.dart';

void main() {
  testWidgets('ToggleSwitch displays correctly with initial state', (WidgetTester tester) async {
    // Arrange
    const bool isToggled = false;

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ToggleSwitch(
            isToggled: isToggled,
            onChanged: (bool value) {},
          ),
        ),
      ),
    );

    // Assert
    final Switch toggleSwitch = tester.widget(find.byType(Switch));
    expect(toggleSwitch.value, isToggled);
    expect(find.text('Outsource computation:'), findsOneWidget);
  });

  testWidgets('ToggleSwitch calls onChanged when tapped', (WidgetTester tester) async {
    // Arrange
    bool isToggled = false;

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ToggleSwitch(
            isToggled: isToggled,
            onChanged: (bool value) {
              isToggled = value;
            },
          ),
        ),
      ),
    );

    // Act
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    // Assert
    expect(isToggled, true);
  });

  testWidgets('ToggleSwitch updates its appearance when the state changes', (WidgetTester tester) async {
    // Arrange
    bool isToggled = false;

    // Act
    await tester.pumpWidget(
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return MaterialApp(
            home: Scaffold(
              body: ToggleSwitch(
                isToggled: isToggled,
                onChanged: (bool value) {
                  setState(() {
                    isToggled = value;
                  });
                },
              ),
            ),
          );
        },
      ),
    );

    // Assert
    expect(find.byType(Switch), findsOneWidget);
    expect((tester.widget(find.byType(Switch)) as Switch).value, false);

    // Act
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    // Assert
    expect((tester.widget(find.byType(Switch)) as Switch).value, true);
  });
}
