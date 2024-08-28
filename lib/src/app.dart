import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:t3_memassist/memory_assistant.dart';

import 'common/settings/domain/usecases/settings_controller.dart';
import 'common/settings/presentation/pages/settings_page.dart';
import 'features/landing/presentation/blocs/blocs.dart';
import 'features/landing/presentation/pages/agreement_page.dart';
import 'features/landing/presentation/pages/home_page.dart';
import 'features/landing/presentation/pages/policy_page.dart';
import 'features/landing/presentation/pages/splash_page.dart';
import 'features/memorization_assistant/presentation/blocs/memo_card_rating/bloc.dart';
import 'features/memorization_assistant/presentation/pages/memo_card_details_page.dart';
import 'features/memorization_assistant/presentation/pages/memo_cards_page.dart';
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
        return MultiBlocProvider(
          providers: [
            BlocProvider<InitializingServicesBloc>(
              create: (BuildContext context) => InitializingServicesBloc(),
            ),
            BlocProvider<AgreementBloc>(
              create: (BuildContext context) => AgreementBloc(),
            ),
            BlocProvider<MemoCardRatingBloc>(
              create: (BuildContext context) => MemoCardRatingBloc(),
            ),
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
                          path: MemoCardsPage.routeName,
                          pageBuilder:
                              (BuildContext context, GoRouterState state) {
                            return const MaterialPage(
                              // If the user leaves and returns to the app after it has
                              // been killed while running in the background, the
                              // navigation stack is restored.
                              restorationId: 'router.root.memoCards',
                              child: MemoCardsPage(),
                            );
                          },
                          routes: <RouteBase>[
                            GoRoute(
                              path:
                                  '${MemoCardDetailsPage.routeName}/:cardName',
                              pageBuilder:
                                  (BuildContext context, GoRouterState state) {
                                final cardName = int.parse(
                                    state.pathParameters['cardName']!);
                                final memoCard = state.extra as MemoCard;

                                return MaterialPage(
                                  // If the user leaves and returns to the app after it
                                  // has been killed while running in the background, the
                                  // navigation stack is restored.
                                  restorationId:
                                      'router.root.memoCards.details',
                                  child: MemoCardDetailsPage(
                                    cardName: cardName,
                                    memoCard: memoCard,
                                  ),
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
                          pageBuilder:
                              (BuildContext context, GoRouterState state) {
                            return MaterialPage(
                              // If the user leaves and returns to the app after it has
                              // been killed while running in the background, the
                              // navigation stack is restored.
                              restorationId: 'router.root.settings',
                              child:
                                  SettingsPage(controller: settingsController),
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
