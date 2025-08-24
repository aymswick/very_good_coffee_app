import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:very_good_coffee/bootstrap.dart';

part 'explore_coffee_event.dart';
part 'explore_coffee_state.dart';

const batchSize = 10;
const throttleDuration = Duration(seconds: 5);

/// Droppable transformer to ignore events added while user is spam-scrolling
EventTransformer<E> throttleDroppable<E>(Duration duration) {
  logger.d('throttle');
  return (events, mapper) =>
      droppable<E>().call(events.throttle(duration), mapper);
}

class ExploreCoffeeBloc extends Bloc<ExploreCoffeeEvent, ExploreCoffeeState> {
  ExploreCoffeeBloc({required this.repository})
    : super(
        const ExploreCoffeeState(
          status: ExploreCoffeeStatus.initial,
        ),
      ) {
    on<CoffeeFetched>(
      _onFetched,
      transformer: throttleDroppable(throttleDuration),
    );
    on<CoffeeFavorited>((event, emit) async {
      try {
        // TODO(ant): save the favorited ones in another list and use hydrated_bloc

        emit(
          state.copyWith(
            status: ExploreCoffeeStatus.success,
            favorites: List.of(state.favorites)..add(event.coffee),
          ),
        );
      } catch (e) {
        logger.e(e);
        emit(state.copyWith(status: ExploreCoffeeStatus.failure));
      }
    });
  }

  CoffeeRepository repository;

  Future<void> _onFetched(
    CoffeeFetched event,
    Emitter<ExploreCoffeeState> emit,
  ) async {
    try {
      if (state.hasReachedMax) return;

      final coffees = await repository.fetchCoffees(
        quantity: batchSize,
        startIndex: state.coffees.length, // future support for paging
      );

      // If our API ever becomes ordered/finite, stop when no more are returned
      if (coffees.isEmpty) {
        return emit(state.copyWith(hasReachedMax: true));
      }

      emit(
        state.copyWith(
          status: ExploreCoffeeStatus.success,
          coffees: List.of(state.coffees)..addAll(coffees),
        ),
      );
    } catch (e) {
      logger.e(e);
      emit(state.copyWith(status: ExploreCoffeeStatus.failure));
    }
  }
}
