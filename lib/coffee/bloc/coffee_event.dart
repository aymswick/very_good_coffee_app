part of 'coffee_bloc.dart';

class CoffeeDownloaded extends CoffeeEvent {
  CoffeeDownloaded({
    required this.coffee,
    required this.cacheKey,
    required this.cacheManager,
    this.storeImage = Gal.putImage,
  });
  final Coffee coffee;
  final String cacheKey;
  final BaseCacheManager cacheManager;
  final Future<void> Function(String path) storeImage;
}

@immutable
sealed class CoffeeEvent {}

class CoffeeFavorited extends CoffeeEvent {
  CoffeeFavorited(this.coffee);
  final Coffee coffee;
}

class CoffeeFetched extends CoffeeEvent {
  CoffeeFetched({this.batchSize = 10});

  final int batchSize;
}

class MessagesReset extends CoffeeEvent {}
