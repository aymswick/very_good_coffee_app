import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:very_good_coffee/app/app.dart';
import 'package:very_good_coffee/coffee/view/coffee_page.dart';
import 'package:very_good_coffee/l10n/l10n.dart';

class App extends StatefulWidget {
  const App({
    required this.createCoffeeRepository,
    required this.httpClient,
    super.key,
  });

  final CoffeeRepository Function() createCoffeeRepository;
  final http.Client httpClient;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<CoffeeRepository>(
      create: (_) => widget.createCoffeeRepository(),
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
    widget.httpClient.close();
  }

  @override
  void initState() {
    super.initState();
  }
}
