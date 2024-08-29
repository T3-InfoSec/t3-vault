import 'package:flutter/material.dart';

class InitializationDialog extends StatelessWidget {
  const InitializationDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Dialog(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 60),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Initializing',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
                'Please wait while we initialize the GreatWall and start derivation\n this might take a little time to finish ...'),
          ],
        ),
      ),
    );
  }
}
