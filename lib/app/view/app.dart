import 'package:alex_flipnote_api_client/alex_flipnote_api_client.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:very_good_coffee/app/app.dart';
import 'package:very_good_coffee/explore_coffee/explore_coffee.dart';
import 'package:very_good_coffee/l10n/l10n.dart';

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ExploreCoffeePage(),
    ),
    GoRoute(
      path: '/favorites',
      builder: (context, state) => const Placeholder(),
    ),
  ],
);

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final http.Client httpClient;
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<CoffeeRepository>(
      create: (context) => CoffeeRepository(
        AlexFlipnoteApiClient(networkClient: httpClient),
      ),
      child: PlatformTheme(
        themeMode: ThemeMode.system,
        materialLightTheme: materialLightTheme,
        materialDarkTheme: materialDarkTheme,
        cupertinoLightTheme: cupertinoLightTheme,
        cupertinoDarkTheme: cupertinoDarkTheme,
        builder: (context) => PlatformApp.router(
          builder: (context, child) => PlatformScaffold(
            body: child,
            bottomNavBar: const PlatformNavBar(
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home)),
                BottomNavigationBarItem(icon: Icon(Icons.favorite)),
              ],
            ),
          ),
          routerConfig: _router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // To support APIs with low rate limits, requests will be retried
    // on any HTTP error up to 3 times, mediated by a growing delay.
    httpClient = RetryClient(
      http.Client(),
      when: (response) => response.statusCode != 200,
    );
  }
}
