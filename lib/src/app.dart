import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:t3_vault/src/features/greatwall_derivation/presentation/pages/derivation_level_page.dart';
import 'package:t3_vault/src/features/greatwall_derivation/presentation/pages/home_page.dart';
import 'package:t3_vault/src/features/greatwall_derivation/presentation/pages/knowledge_types_page.dart';
import 'package:t3_vault/src/features/greatwall_derivation/presentation/pages/tree_input_parameters_page.dart';

import 'core/settings/domain/usecases/settings_controller.dart';
import 'core/settings/presentation/pages/settings_page.dart';
import 'features/sample/sample_item_details_view.dart';
import 'features/sample/sample_item_list_view.dart';

/// The Widget that configures your application.
class T3Vault extends StatelessWidget {
  final SettingsController settingsController;

  const T3Vault({
    super.key,
    required this.settingsController,
  });

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp.router(
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'T3Vault',

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          routerConfig: GoRouter(
            restorationScopeId: 'router',
            routes: <RouteBase>[
              GoRoute(
                path: '/',
                builder: (BuildContext context, GoRouterState state) {
                  // This route directs to the HomePage, which is a temporarily placeholder for testing purposes.
                  return const HomePage();
                },
              ),
              GoRoute(
                path: SampleItemListView.routeName,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return const MaterialPage(
                    // If the user leaves and returns to the app after it has
                    // been killed while running in the background, the
                    // navigation stack is restored.
                    restorationId: 'router.list',
                    child: SampleItemListView(),
                  );
                },
                routes: <RouteBase>[
                  GoRoute(
                    path: SampleItemDetailsView.routeName,
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      return const MaterialPage(
                        // If the user leaves and returns to the app after it
                        // has been killed while running in the background, the
                        // navigation stack is restored.
                        restorationId: 'router.list.details',
                        child: SampleItemDetailsView(),
                      );
                    },
                  ),
                ],
              ),
              GoRoute(
                path: SettingsPage.routeName,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return MaterialPage(
                    // If the user leaves and returns to the app after it has
                    // been killed while running in the background, the
                    // navigation stack is restored.
                    restorationId: 'router.settings',
                    child: SettingsPage(controller: settingsController),
                  );
                },
              ),
              GoRoute(
                path: '/knowledge_types',
                builder: (BuildContext context, GoRouterState state) {
                  return const KnowledgeTypesPage();
                },
              ),
              GoRoute(
                path: '/tree_input_parameters',
                builder: (BuildContext context, GoRouterState state) {
                  return const TreeInputsParametersPage();
                },
              ),
              GoRoute(
                path: '/derivation_level',
                builder: (BuildContext context, GoRouterState state) {
                  return const DerivationLevelPage();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
