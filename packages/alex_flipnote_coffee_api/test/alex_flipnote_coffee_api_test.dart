import 'package:alex_flipnote_coffee_api/src/alex_flipnote_coffee_api.dart';
import 'package:coffee_api/coffee_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

void main() {
  late http.Client httpClient;
  late AlexFlipnoteCoffeeApi api;

  setUp(() {
    httpClient = MockHttpClient();
    api = AlexFlipnoteCoffeeApi(networkClient: httpClient);
    registerFallbackValue(Uri(path: 'example'));
  });
  test('getCoffee emits all coffees in order', () {
    when(() => httpClient.read(any())).thenAnswer(
      (_) async => Future.value('{"file": "https://example.com/test"}'),
    );
    expect(
      api.getCoffee(startIndex: 0, quantity: 10),
      emitsInOrder(testCoffees),
    );
  });

  test(
    'getCoffee completes streaming / fetching if an invalid JSON value is delivered',
    () {
      when(
        () => httpClient.read(any()),
      ).thenAnswer((_) async => Future.value('NOT JSON'));

      final result = api.getCoffee(startIndex: 0, quantity: 10);

      expect(result, isA<Stream>());
      expect(result, isNot(throwsA(Exception())));
      expect(result, emitsInOrder(List<Stream>.empty()));
    },
  );
}

final List<Coffee> testCoffees = List.generate(
  10,
  (int index) =>
      Coffee(url: Uri.parse('https://example.com/test'), name: 'test'),
);

class MockHttpClient extends Mock implements http.Client {}
