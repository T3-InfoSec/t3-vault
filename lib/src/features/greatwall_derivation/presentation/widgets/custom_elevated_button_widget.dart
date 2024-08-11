import 'package:flutter/material.dart';

/// A customizable elevated button widget that can be reused across multiple pages.
///
/// The [CustomElevatedButton] widget is a reusable button component with a predefined
/// style, including a fixed width, height, and background color. It accepts a [text] 
/// parameter to display as the button's label and an [onPressed] callback function that 
/// defines the action when the button is pressed.
///
/// This widget is designed to maintain a consistent appearance for elevated buttons 
/// throughout the application, ensuring uniformity in the UI design.
///
/// Example usage:
/// ```dart
/// CustomElevatedButton(
///   text: 'Submit',
///   onPressed: () {
///     // Handle button press action here
///   },
/// )
/// ```
class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  /// Creates a [CustomElevatedButton] with the given [text] and [onPressed] callback.
  ///
  /// The [text] parameter specifies the label displayed on the button, and the 
  /// [onPressed] callback is triggered when the button is tapped.
  const CustomElevatedButton({
    required this.text,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF70A8FF),
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}