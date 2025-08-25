import 'package:alex_flipnote_coffee_api/alex_flipnote_coffee_api.dart';
import 'package:coffee_api/coffee_api.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  group('CoffeeRepository', () {
    late AlexFlipnoteCoffeeApi api;
    late CoffeeRepository repository;

    final testCoffees = List.generate(
      3,
      (index) => Coffee(
        name: 'Coffee_$index',
        url: Uri.parse("https://example_coffee_$index.jpg"),
      ),
    );

    setUp(() {
      api = MockAlexFlipnoteApi();
      repository = CoffeeRepository(api);
      when(
        () => api.getCoffee(
          startIndex: any(named: 'startIndex'),
          quantity: any(named: 'quantity'),
        ),
      ).thenAnswer((_) => Stream.fromIterable(testCoffees));
    });

    test(
      'getCoffee emits a stream of coffees in the order they are received',
      () {
        expect(
          repository.getCoffee(startIndex: 0, quantity: 5),
          emitsInOrder(testCoffees),
        );
      },
    );
  });
}

class MockAlexFlipnoteApi extends Mock implements AlexFlipnoteCoffeeApi {}
