import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:coffee_api/coffee_api.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:gal/gal.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:very_good_coffee/bootstrap.dart';

part 'coffee_event.dart';
part 'coffee_state.dart';

/// Droppable transformer to ignore events added while user is spam-scrolling
EventTransformer<E> throttleDroppable<E>(Duration duration) {
  logger.d('throttle');
  return (events, mapper) =>
      droppable<E>().call(events.throttle(duration), mapper);
}

class CoffeeBloc extends Bloc<CoffeeEvent, CoffeeState> {
  CoffeeBloc({required this.repository})
    : super(
        const CoffeeState(),
      ) {
    on<CoffeeFetched>(
      _onFetched,
      transformer: throttleDroppable(throttleDuration),
    );
    on<CoffeeFavorited>(_onFavorited);
    on<CoffeeDownloaded>(_onDownloaded);
    on<MessagesReset>(_onMessagesReset);
  }

  CoffeeRepository repository;

  Future<void> _onDownloaded(
    CoffeeDownloaded event,
    Emitter<CoffeeState> emit,
  ) async {
    try {
      final imageFile = await event.cacheManager.getFileFromCache(
        event.cacheKey,
      );

      // TODO(ant): should set up a proper function type for gallery/image storage
      try {
        await event.storeImage(
          imageFile!.file.path,
        );
      } on Exception catch (e) {
        logger.e(e);
        throw SaveToGalleryException();
      }

      emit(
        state.copyWith(
          status: CoffeeStatus.success,
          downloads: List.of(state.downloads)..add(event.coffee),
          message: '${event.coffee.name} saved to gallery!',
        ),
      );
    } catch (e) {
      logger.e(e);
      emit(state.copyWith(status: CoffeeStatus.failure, message: '$e'));
    }
  }

  Future<void> _onFavorited(
    CoffeeFavorited event,
    Emitter<CoffeeState> emit,
  ) async {
    try {
      final favorites = List<Coffee>.of(state.favorites);

      if (state.favorites.contains(event.coffee)) {
        favorites.remove(event.coffee);
      } else {
        favorites.add(event.coffee);
      }

      emit(
        state.copyWith(
          status: CoffeeStatus.success,
          favorites: favorites
            ..toSet() // Ensure only 1 copy of each is ever emitted
                .toList(),
        ),
      );
    } catch (e) {
      logger.e(e);
      emit(state.copyWith(status: CoffeeStatus.failure));
    }
  }

  Future<void> _onFetched(
    CoffeeFetched event,
    Emitter<CoffeeState> emit,
  ) async {
    try {
      if (state.hasReachedMax) return;

      // oops bug emitting one entry lists
      await emit.forEach(
        repository.getCoffee(
          quantity: event.batchSize,
          startIndex: state.coffees.length, // future support for paging
        ),
        onData: (coffee) => state.copyWith(
          coffees: List.of(state.coffees)..add(coffee),
          status: CoffeeStatus.success,
          // message: coffees.last.name,
        ),
        onError: (error, stackTrace) =>
            state.copyWith(status: CoffeeStatus.failure),
      );
    } on ClientException catch (e) {
      logger.e(e);
      // TODO(ant): connectivity_plus is a more robust solution for guarding the app based on network state
      emit(
        state.copyWith(status: CoffeeStatus.failure, message: 'Network Error'),
      );
    } on Exception catch (e) {
      emit(state.copyWith(status: CoffeeStatus.failure, message: e.toString()));
    }
  }

  Future<void> _onMessagesReset(
    MessagesReset event,
    Emitter<CoffeeState> emit,
  ) async {
    emit(state.copyWith(message: ''));
  }
}

class SaveToGalleryException implements Exception {
  @override
  String toString() {
    return 'SaveToGalleryException';
  }
}
