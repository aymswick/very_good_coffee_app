import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee/coffee/coffee.dart';
import 'package:very_good_coffee/l10n/gen/app_localizations.dart';
import 'package:very_good_coffee/l10n/gen/app_localizations_en.dart';

export 'pump_app.dart';

AppLocalizations get l10n => AppLocalizationsEn();

class MockCacheManager extends Mock implements BaseCacheManager {}

class MockCoffeeBloc extends MockBloc<CoffeeEvent, CoffeeState>
    implements CoffeeBloc {}

class MockCoffeeRepository extends Mock implements CoffeeRepository {}

class MockFile extends Mock implements File {}

class MockFileInfo extends Mock implements FileInfo {}

class MockHttpClient extends Mock implements Client {}
