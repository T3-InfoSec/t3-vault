import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:t3_vault/src/features/greatwall_derivation/presentation/widgets/toggle_switch_widget.dart';

void main() {
  testWidgets('ToggleSwitch displays correctly with initial state', (WidgetTester tester) async {

    const bool isToggled = false;

    // Build the ToggleSwitch widget.
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

    // Verify that the toggle switch shows the correct initial state.
    final Switch toggleSwitch = tester.widget(find.byType(Switch));
    expect(toggleSwitch.value, isToggled);

    // Verify that the label is displayed correctly.
    expect(find.text('Outsource computation:'), findsOneWidget);
  });

  testWidgets('ToggleSwitch calls onChanged when tapped', (WidgetTester tester) async {
    bool isToggled = false;

    // Build the ToggleSwitch widget with an onChanged callback.
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

    // Tap the toggle switch to change its state.
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    // Verify that the onChanged callback was called and the state was updated.
    expect(isToggled, true);
  });

  testWidgets('ToggleSwitch updates its appearance when the state changes', (WidgetTester tester) async {
    bool isToggled = false;

    // Build the ToggleSwitch widget.
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

    // Verify initial state.
    expect(find.byType(Switch), findsOneWidget);
    expect((tester.widget(find.byType(Switch)) as Switch).value, false);

    // Tap the toggle switch to change its state.
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    // Verify the toggle switch appearance is updated.
    expect((tester.widget(find.byType(Switch)) as Switch).value, true);
  });
}
