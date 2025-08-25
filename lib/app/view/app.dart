import 'package:alex_flipnote_coffee_api/alex_flipnote_coffee_api.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:very_good_coffee/app/app.dart';
import 'package:very_good_coffee/coffee/view/coffee_page.dart';
import 'package:very_good_coffee/l10n/l10n.dart';

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
        AlexFlipnoteCoffeeApi(networkClient: httpClient),
      ),
      child: PlatformTheme(
        themeMode: ThemeMode.system,
        materialLightTheme: materialLightTheme,
        materialDarkTheme: materialDarkTheme,
        cupertinoLightTheme: cupertinoLightTheme,
        cupertinoDarkTheme: cupertinoDarkTheme,
        builder: (context) => PlatformApp(
          home: const SafeArea(child: CoffeePage()),
          builder: (context, child) => PlatformScaffold(
            body: Material(child: child),
          ),
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
    // This is particularly useful for Alex's API which sends
    // HTTP 429 (Too Many Requests) errors when scrolling fast.
    httpClient = RetryClient(
      http.Client(),
      when: (response) => response.statusCode != 200,
    );
  }
}
