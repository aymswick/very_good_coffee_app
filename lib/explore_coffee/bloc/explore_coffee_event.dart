part of 'explore_coffee_bloc.dart';

class CoffeeFavorited extends ExploreCoffeeEvent {
  CoffeeFavorited(this.coffee);
  final Coffee coffee;
}

@immutable
sealed class ExploreCoffeeEvent {}

class CoffeeFetched extends ExploreCoffeeEvent {}
