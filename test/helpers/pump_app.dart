import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_coffee/bootstrap.dart';
import 'package:very_good_coffee/l10n/l10n.dart';

import 'helpers.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(Widget widget, {CoffeeRepository? repository}) async {
    await pumpWidget(
      RepositoryProvider.value(
        value: repository ?? MockCoffeeRepository(),
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Material(child: Scaffold(body: widget)),
        ),
      ),
    );
    return pump(throttleDuration);
  }
}
