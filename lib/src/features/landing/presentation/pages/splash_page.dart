import 'package:flutter/material.dart';

/// Displays a list of SampleItems.
class SplashPage extends StatelessWidget {
  static const routeName = 'splash';

  const SplashPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(),
          Image.asset(
            "assets/images/flutter_logo.png",
            width: 100,
            height: 100,
          ),
          Column(
            children: [
              Text(
                "from",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/flutter_logo.png",
                    color: theme.colorScheme.onSurface,
                    width: 35,
                    height: 35,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "T3-InfoSec",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
