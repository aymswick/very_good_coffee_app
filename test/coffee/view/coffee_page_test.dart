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
        when(() => bloc.state).thenReturn(
          CoffeeState(
            status: CoffeeStatus.success,
            coffees: testCoffees,
            favorites: testCoffees.sublist(0, 2),
          ),
        );
      });

      testWidgets('displays CoffeeList of CoffeeItem', (tester) async {
        await tester.pumpApp(buildCoffeeView(), repository: repository);

        expect(find.byType(CoffeeList), findsOneWidget);
        expect(find.byType(CoffeeItem), findsNWidgets(5));
      });

      testWidgets('displays only favorites when filtered', (
        tester,
      ) async {
        await tester.pumpApp(buildCoffeeView(), repository: repository);

        await tester.tap(find.byType(FilterChip));
        await tester.pump();

        expect(
          find.byType(CoffeeItem),
          findsNWidgets(2),
        );
      });

      testWidgets('download icon state changes color when tapped', (
        tester,
      ) async {
        await tester.pumpApp(buildCoffeeView(), repository: repository);
        final downloadButton = find
            .byKey(const Key('download_coffee_btn'))
            .first;
        await tester.tap(downloadButton);

        expect((downloadButton as IconButton).color, Colors.blue);
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
