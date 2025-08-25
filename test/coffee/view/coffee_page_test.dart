import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_api/coffee_api.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee/coffee/coffee.dart';

import '../../helpers/helpers.dart';

void main() {
  group('CoffeePage', () {
    late CoffeeBloc bloc;
    late CoffeeRepository repository;

    setUp(() {
      bloc = MockCoffeeBloc();
      repository = MockCoffeeRepository();
      when(
        () => repository.getCoffee(
          startIndex: any(named: 'startIndex'),
          quantity: any(named: 'quantity'),
        ),
      ).thenAnswer((_) => const Stream<Coffee>.empty());
    });

    Widget buildCoffeeView() => BlocProvider.value(
      value: bloc,
      child: const CoffeeView(),
    );

    testWidgets('renders CoffeeView', (tester) async {
      await tester.pumpApp(const CoffeePage(), repository: repository);
      expect(find.byType(CoffeeView), findsOneWidget);
    });

    testWidgets('streams coffees on initial load', (tester) async {
      await tester.pumpApp(const CoffeePage(), repository: repository);
      verify(
        () => repository.getCoffee(
          startIndex: any(named: 'startIndex'),
          quantity: any(named: 'quantity'),
        ),
      ).called(1);
    });

    group('CoffeeView', () {
      setUp(() {
        registerFallbackValue(
          Coffee(url: Uri.parse('https://dummy.com'), name: 'dummy'),
        );

        registerFallbackValue(MockCacheManager());
        registerFallbackValue(CoffeeFetched());
      });

      testWidgets('displays CoffeeList of CoffeeItem', (tester) async {
        when(() => bloc.state).thenReturn(
          CoffeeState(
            status: CoffeeStatus.success,
            coffees: testCoffees,
            favorites: testCoffees.sublist(0, 2),
          ),
        );
        await tester.pumpApp(buildCoffeeView(), repository: repository);

        expect(find.byType(CoffeeList), findsOneWidget);
        expect(find.byType(CoffeeItem), findsNWidgets(5));
      });

      testWidgets('displays only favorites when filtered', (
        tester,
      ) async {
        when(() => bloc.state).thenReturn(
          CoffeeState(
            status: CoffeeStatus.success,
            coffees: testCoffees,
            favorites: testCoffees.sublist(0, 2),
          ),
        );
        await tester.pumpApp(buildCoffeeView(), repository: repository);

        await tester.tap(find.byType(FilterChip));
        await tester.pump();

        expect(
          find.byType(CoffeeItem),
          findsNWidgets(2),
        );
      });

      testWidgets(
        'displays empty list when favorites are empty when filtered',
        (
          tester,
        ) async {
          when(() => bloc.state).thenReturn(
            CoffeeState(
              status: CoffeeStatus.success,
              coffees: testCoffees,
              favorites: testCoffees.sublist(0, 2),
            ),
          );
          whenListen(
            bloc,
            Stream.value(
              CoffeeState(status: CoffeeStatus.success, coffees: testCoffees),
            ),
          );
          await tester.pumpApp(buildCoffeeView(), repository: repository);

          expect(find.byType(CoffeeItem), findsAtLeast(1));

          await tester.tap(find.byType(FilterChip));
          await tester.pump();

          expect(find.byType(CoffeeItem), findsNothing);
        },
      );

      testWidgets('adds CoffeeFavorited event when favorite button tapped', (
        tester,
      ) async {
        when(() => bloc.state).thenReturn(
          CoffeeState(
            status: CoffeeStatus.success,
            coffees: testCoffees,
            favorites: testCoffees.sublist(0, 2),
          ),
        );
        await tester.pumpApp(buildCoffeeView(), repository: repository);
        await tester.pump(Durations.short1);

        await tester.tap(find.byKey(const Key('favorite_coffee_btn')).first);
        await tester.pump();

        verify(
          () => bloc.add(
            any(that: isA<CoffeeFavorited>()),
          ),
        ).called(1);
      });

      testWidgets('adds CoffeeDownloaded event when download button tapped', (
        tester,
      ) async {
        when(() => bloc.state).thenReturn(
          CoffeeState(
            status: CoffeeStatus.success,
            coffees: testCoffees,
            favorites: testCoffees.sublist(0, 2),
          ),
        );
        await tester.pumpApp(buildCoffeeView(), repository: repository);
        final downloadButton = find
            .byKey(const Key('download_coffee_btn'))
            .first;

        await tester.tap(downloadButton);

        verify(
          () => bloc.add(any(that: isA<CoffeeDownloaded>())),
        ).called(1);
      });

      testWidgets('adds CoffeeFetched event when scrolling', (
        tester,
      ) async {
        when(() => bloc.state).thenReturn(
          CoffeeState(
            status: CoffeeStatus.success,
            coffees: testCoffees,
            favorites: testCoffees.sublist(0, 2),
          ),
        );

        await tester.pumpApp(buildCoffeeView(), repository: repository);

        final list = find.byType(Scrollable);
        final bottom = find.byType(BottomLoader);

        await tester.scrollUntilVisible(bottom, 10, scrollable: list);

        await tester.pump();

        verify(
          () => bloc.add(any(that: isA<CoffeeFetched>())),
        ).called(1);
      });
      testWidgets('resets message after emitting', (
        tester,
      ) async {
        when(() => bloc.state).thenReturn(
          CoffeeState(
            status: CoffeeStatus.success,
            coffees: testCoffees,
            favorites: testCoffees.sublist(0, 2),
          ),
        );
        whenListen(
          bloc,
          Stream.fromIterable([
            CoffeeState(
              status: CoffeeStatus.success,
              coffees: testCoffees,
              message: 'test message',
            ),
            CoffeeState(
              status: CoffeeStatus.failure,
              coffees: testCoffees,
              message: 'test message',
            ),
          ]),
        );

        await tester.pumpApp(buildCoffeeView(), repository: repository);

        verify(
          () => bloc.add(any(that: isA<MessagesReset>())),
        ).called(2);
      });
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
