import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee/explore_coffee/explore_coffee.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ExploreCoffeePage', () {
    testWidgets('renders ExploreCoffeeView', (tester) async {
      await tester.pumpApp(const ExploreCoffeePage());
      expect(find.byType(ExploreCoffeeView), findsOneWidget);
    });
  });

  group('ExploreCoffeeView', () {
    late ExploreCoffeeBloc bloc;

    setUp(() {
      bloc = MockExploreCoffeeBloc();
    });

    testWidgets('renders current count', (tester) async {
      const state = ExploreCoffeeState(
        status: ExploreCoffeeStatus.initial,
      );
      when(() => bloc.state).thenReturn(state);
      await tester.pumpApp(
        BlocProvider.value(
          value: bloc,
          child: const ExploreCoffeeView(),
        ),
      );
      expect(find.byType(ExploreCoffeePage), findsOneWidget);
    });
  });
}

class MockExploreCoffeeBloc
    extends MockBloc<ExploreCoffeeEvent, ExploreCoffeeState>
    implements ExploreCoffeeBloc {}
