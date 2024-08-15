import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/settings/presentation/pages/settings_page.dart';
import '../../../sample/sample_item_list_view.dart';

/// Displays a list of SampleItems.
class HomePage extends StatelessWidget {
  static const routeName = '/';

  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('T3-Vault'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            // iconSize: 300,
            onPressed: () {
              // Navigate to the settings page.
              context.go('/${SettingsPage.routeName}');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(),
            Image.asset(
              "assets/images/flutter_logo.png",
              width: 100,
              height: 100,
            ),
            const SizedBox(
              height: 30,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.go('/${SampleItemListView.routeName}');
                  },
                  child: const Text('Derive Your Keys!'),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    context.go('/${SampleItemListView.routeName}');
                  },
                  child: const Text('Memorize Your Keys!'),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
