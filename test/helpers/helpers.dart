import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee/coffee/coffee.dart';

export 'pump_app.dart';

class MockCacheManager extends Mock implements BaseCacheManager {}

class MockCoffeeBloc extends MockBloc<CoffeeEvent, CoffeeState>
    implements CoffeeBloc {}

class MockCoffeeRepository extends Mock implements CoffeeRepository {}

class MockFile extends Mock implements File {}

class MockFileInfo extends Mock implements FileInfo {}
