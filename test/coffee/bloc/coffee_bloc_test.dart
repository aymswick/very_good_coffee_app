import 'package:bloc_test/bloc_test.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_api/coffee_api.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee/bootstrap.dart';
import 'package:very_good_coffee/coffee/coffee.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('CoffeeBloc', () {
    late CoffeeRepository coffeeRepository;
    late CoffeeBloc coffeeBloc;

    setUp(() {
      coffeeRepository = MockCoffeeRepository();
      coffeeBloc = CoffeeBloc(repository: coffeeRepository);
      CachedNetworkImageProvider.defaultCacheManager = MockCacheManager();
    });

    test('initial state correct', () {
      final coffeeBloc = CoffeeBloc(repository: coffeeRepository);
      expect(coffeeBloc.state, const CoffeeState());
    });

    group('fetchCoffee', () {
      blocTest(
        'emits single coffee',
        setUp: () {
          when(
            () => coffeeRepository.getCoffee(
              startIndex: any(named: 'startIndex'),
              quantity: 1,
            ),
          ).thenAnswer((_) => Stream.fromIterable([testCoffees.first]));
        },
        build: () => coffeeBloc,
        act: (bloc) => bloc.add(CoffeeFetched(batchSize: 1)),
        expect: () => [
          CoffeeState(
            status: CoffeeStatus.success,
            coffees: [testCoffees.first],
          ),
        ],
      );
      blocTest(
        'emits correct quantity of coffees',
        setUp: () {
          when(
            () => coffeeRepository.getCoffee(
              startIndex: any(named: 'startIndex'),
              quantity: 5,
            ),
          ).thenAnswer((_) => Stream.fromIterable(testCoffees));
        },
        build: () => coffeeBloc,
        act: (bloc) => bloc.add(CoffeeFetched(batchSize: 5)),
        expect: () => [
          CoffeeState(
            status: CoffeeStatus.success,
            coffees: [testCoffees.first],
          ),
          CoffeeState(
            status: CoffeeStatus.success,
            coffees: testCoffees.sublist(0, 2),
          ),
          CoffeeState(
            status: CoffeeStatus.success,
            coffees: testCoffees.sublist(0, 3),
          ),
          CoffeeState(
            status: CoffeeStatus.success,
            coffees: testCoffees.sublist(0, 4),
          ),
          CoffeeState(
            status: CoffeeStatus.success,
            coffees: testCoffees.sublist(0, 5),
          ),
        ],
      );
    });

    group('favoriteCoffee', () {
      blocTest(
        'emits appended list when coffee not already favorited',
        build: () => coffeeBloc,
        act: (bloc) => bloc.add(CoffeeFavorited(testCoffees.first)),
        expect: () => [
          CoffeeState(
            status: CoffeeStatus.success,
            favorites: [testCoffees.first],
          ),
        ],
      );
      blocTest(
        'emits truncated list when coffee is already favorited',
        build: () => coffeeBloc,
        seed: () => CoffeeState(
          status: CoffeeStatus.success,
          favorites: [testCoffees.first],
        ),
        act: (bloc) => bloc.add(CoffeeFavorited(testCoffees.first)),
        expect: () => [
          const CoffeeState(
            status: CoffeeStatus.success,
          ),
        ],
      );
    });

    group('downloadCoffee', () {
      late FileInfo mockFileInfo;
      late BaseCacheManager mockCacheManager;
      late File mockFile;

      setUp(() {
        mockFileInfo = MockFileInfo();
        mockCacheManager = MockCacheManager();
        mockFile = MockFile();
      });

      blocTest(
        'emits success message and appends download list',
        setUp: () {
          when(
            () => mockCacheManager.getFileFromCache(any()),
          ).thenAnswer((_) async => mockFileInfo);
          when(() => mockFileInfo.file).thenReturn(mockFile);
          when(() => mockFile.path).thenReturn('fakePath');
        },
        build: () => coffeeBloc,
        act: (bloc) => bloc.add(
          CoffeeDownloaded(
            coffee: testCoffees.first,
            cacheKey: 'fakeKey',
            cacheManager: mockCacheManager,
            storeImage: (path) async {
              logger.d('faking store image');
            },
          ),
        ),
        expect: () => [
          CoffeeState(
            status: CoffeeStatus.success,
            downloads: [testCoffees.first],
            message: '${testCoffees.first.name} saved to gallery!',
          ),
        ],
      );
      blocTest(
        'emits failure when image not present in cache',
        setUp: () {
          when(
            () => mockCacheManager.getFileFromCache(any()),
          ).thenAnswer((_) async => null);
          when(() => mockFileInfo.file).thenReturn(mockFile);
          when(() => mockFile.path).thenReturn('fakePath');
        },
        build: () => coffeeBloc,
        act: (bloc) => bloc.add(
          CoffeeDownloaded(
            coffee: testCoffees.first,
            cacheKey: 'fakeKey',
            cacheManager: mockCacheManager,
            storeImage: (path) async {
              logger.d('faking store image');
            },
          ),
        ),
        expect: () => [
          const CoffeeState(
            status: CoffeeStatus.failure,
            message: 'ImageCacheMissException',
          ),
        ],
      );
      blocTest(
        'emits failure when storeImage fails, possible due to permissions',
        setUp: () {
          when(
            () => mockCacheManager.getFileFromCache(any()),
          ).thenAnswer((_) async => mockFileInfo);
          when(() => mockFileInfo.file).thenReturn(mockFile);
          when(() => mockFile.path).thenReturn('fakePath');
        },
        build: () => coffeeBloc,
        act: (bloc) => bloc.add(
          CoffeeDownloaded(
            coffee: testCoffees.first,
            cacheKey: 'fakeKey',
            cacheManager: mockCacheManager,
            storeImage: (path) async {
              throw Exception('Simulated error');
            },
          ),
        ),
        expect: () => [
          const CoffeeState(
            status: CoffeeStatus.failure,
            message: 'SaveToGalleryException',
          ),
        ],
      );
    });

    group('messagesReset', () {
      blocTest(
        'emits blank message (wipe) after displaying',
        seed: () =>
            const CoffeeState(message: 'There is something to display!'),
        build: () => coffeeBloc,
        act: (bloc) => bloc.add(MessagesReset()),
        expect: () => [
          const CoffeeState(
            message: '',
          ),
        ],
      );
    });
  });
}

final List<Coffee> testCoffees = List.generate(
  5,
  (int index) => Coffee(
    url: Uri.parse('https://example.com/coffee_$index.jpg'),
    name: 'Example Coffee $index',
  ),
);
