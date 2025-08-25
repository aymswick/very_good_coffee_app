// Ignore for testing purposes
// ignore_for_file: prefer_const_constructors

import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee/app/app.dart';
import 'package:very_good_coffee/bootstrap.dart';
import 'package:very_good_coffee/coffee/coffee.dart';

import '../../helpers/helpers.dart';

void main() {
  group('App', () {
    late CoffeeBloc bloc;
    late CoffeeRepository coffeeRepository;

    setUp(() {
      coffeeRepository = MockCoffeeRepository();
      bloc = MockCoffeeBloc();
      when(() => bloc.state).thenAnswer((_) => CoffeeState());
      when(
        () => coffeeRepository.getCoffee(
          startIndex: any(named: 'startIndex'),
          quantity: any(named: 'quantity'),
        ),
      ).thenAnswer((_) => const Stream.empty());
    });

    testWidgets('renders a PlatformApp', (tester) async {
      await tester.pumpWidget(
        App(
          createCoffeeRepository: () => coffeeRepository,
          httpClient: MockHttpClient(),
        ),
      );

      await tester.pump(throttleDuration);

      expect(find.byType(PlatformApp), findsOneWidget);
    });
  });
}
