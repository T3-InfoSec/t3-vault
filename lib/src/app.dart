import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'common/settings/domain/usecases/settings_controller.dart';
import 'common/settings/presentation/pages/settings_page.dart';
import 'features/greatwall_derivation/presentation/bloc/bloc.dart';
import 'features/greatwall_derivation/presentation/pages/confirmation_page.dart';
import 'features/greatwall_derivation/presentation/pages/derivation_level_page.dart';
import 'features/greatwall_derivation/presentation/pages/derivation_result_page.dart';
import 'features/greatwall_derivation/presentation/pages/knowledge_types_page.dart';
import 'features/greatwall_derivation/presentation/pages/tree_inputs_page.dart';
import 'features/landing/presentation/blocs/blocs.dart';
import 'features/landing/presentation/pages/agreement_page.dart';
import 'features/landing/presentation/pages/home_page.dart';
import 'features/landing/presentation/pages/policy_page.dart';
import 'features/landing/presentation/pages/splash_page.dart';
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
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<InitializingServicesBloc>(
              create: (BuildContext context) => InitializingServicesBloc(),
            ),
            BlocProvider<AgreementBloc>(
              create: (BuildContext context) => AgreementBloc(),
            ),
                        BlocProvider<GreatWallBloc>(
              create: (context) => GreatWallBloc(),)
          ],
          child: Builder(
            builder: (context) {
              final agreementState = context.watch<AgreementBloc>().state;

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
                theme: ThemeData(
                  useMaterial3: true,
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: Colors.deepPurpleAccent,
                  ),
                ),
                darkTheme: ThemeData.dark(),
                themeMode: settingsController.themeMode,

                // Define a function to handle named routes in order to support
                // Flutter web url navigation and deep linking.
                routerConfig: GoRouter(
                  restorationScopeId: 'router',
                  routes: <RouteBase>[
                    GoRoute(
                      path: HomePage.routeName,
                      pageBuilder: (BuildContext context, GoRouterState state) {
                        return const MaterialPage(
                          // If the user leaves and returns to the app after it has
                          // been killed while running in the background, the
                          // navigation stack is restored.
                          restorationId: 'router.root',
                          child: HomePage(),
                        );
                      },
                      redirect: (BuildContext context, GoRouterState state) {
                        switch (agreementState) {
                          case AgreementStateSuspend():
                            return '/agreement/policy';
                          case AgreementStateAccept():
                            return null;
                          case AgreementStateReject():
                            return '/agreement';
                        }
                      },
                      routes: <RouteBase>[
                        GoRoute(
                          path: SplashPage.routeName,
                          pageBuilder:
                              (BuildContext context, GoRouterState state) {
                            return const MaterialPage(
                              child: SplashPage(),
                            );
                          },
                        ),
                        GoRoute(
                          path: AgreementPage.routeName,
                          pageBuilder:
                              (BuildContext context, GoRouterState state) {
                            return const MaterialPage(
                              // If the user leaves and returns to the app after it has
                              // been killed while running in the background, the
                              // navigation stack is restored.
                              restorationId: 'router.root.agreement',
                              child: AgreementPage(),
                            );
                          },
                          routes: <RouteBase>[
                            GoRoute(
                              path: PolicyPage.routeName,
                              pageBuilder: (
                                BuildContext context,
                                GoRouterState state,
                              ) {
                                return const MaterialPage(
                                  // If the user leaves and returns to the app after it has
                                  // been killed while running in the background, the
                                  // navigation stack is restored.
                                  restorationId:
                                      'router.root.agreement.content',
                                  child: PolicyPage(),
                                );
                              },
                            ),
                          ],
                        ),
                        GoRoute(
                          path: SampleItemListView.routeName,
                          pageBuilder:
                              (BuildContext context, GoRouterState state) {
                            return const MaterialPage(
                              // If the user leaves and returns to the app after it has
                              // been killed while running in the background, the
                              // navigation stack is restored.
                              restorationId: 'router.root.sampleItemListView',
                              child: SampleItemListView(),
                            );
                          },
                          routes: <RouteBase>[
                            GoRoute(
                              path: SampleItemDetailsView.routeName,
                              pageBuilder:
                                  (BuildContext context, GoRouterState state) {
                                return const MaterialPage(
                                  // If the user leaves and returns to the app after it
                                  // has been killed while running in the background, the
                                  // navigation stack is restored.
                                  restorationId:
                                      'router.root.sampleItemListView.details',
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
                              restorationId: 'router.root.settings',
                              child: SettingsPage(controller: settingsController),
                            );
                          },
                        ),
                        GoRoute(
                          path: KnowledgeTypesPage.routeName,
                          pageBuilder: (BuildContext context, GoRouterState state) {
                            return const MaterialPage(
                              restorationId: 'router.root.knowledge_types',
                              child: KnowledgeTypesPage(),
                            );
                          },
                        ),
                        GoRoute(
                          path: TreeInputsPage.routeName,
                          pageBuilder: (BuildContext context, GoRouterState state) {
                            return MaterialPage(
                              restorationId: 'router.root.tree_inputs',
                              child: TreeInputsPage(),
                            );
                          },
                        ),
                        GoRoute(
                          path: ConfirmationPage.routeName,
                          pageBuilder: (BuildContext context, GoRouterState state) {
                            return const MaterialPage(
                              restorationId: 'router.root.derivation_seed',
                              child: ConfirmationPage(),
                            );
                          },
                        ),
                        GoRoute(
                          path: DerivationLevelPage.routeName,
                          pageBuilder: (BuildContext context, GoRouterState state) {
                            return const MaterialPage(
                              restorationId: 'router.root.derivation_level',
                              child: DerivationLevelPage(),
                            );
                          },
                        ),
                        GoRoute(
                          path: DerivationResultPage.routeName,
                          pageBuilder: (BuildContext context, GoRouterState state) {
                            return const MaterialPage(
                              restorationId: 'router.root.derivation_result',
                              child: DerivationResultPage(),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
