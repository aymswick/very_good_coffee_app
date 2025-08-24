part of 'explore_coffee_bloc.dart';

class ExploreCoffeeState extends Equatable {
  const ExploreCoffeeState({
    required this.status,
    this.coffees = const [],
    this.favorites = const [],
    this.hasReachedMax = false,
  });

  final List<Coffee> coffees;
  final List<Coffee> favorites;
  final ExploreCoffeeStatus status;
  final bool hasReachedMax;

  @override
  List<Object?> get props => [
    status,
    coffees,
    favorites,
    hasReachedMax,
  ];

  ExploreCoffeeState copyWith({
    List<Coffee>? coffees,
    List<Coffee>? favorites,
    ExploreCoffeeStatus? status,
    bool? hasReachedMax,
  }) => ExploreCoffeeState(
    status: status ?? this.status,
    coffees: coffees ?? this.coffees,
    favorites: favorites ?? this.favorites,
    hasReachedMax: hasReachedMax ?? this.hasReachedMax,
  );
}

enum ExploreCoffeeStatus { initial, success, failure }
