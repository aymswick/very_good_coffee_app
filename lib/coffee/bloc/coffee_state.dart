part of 'coffee_bloc.dart';

class CoffeeState extends Equatable {
  const CoffeeState({
    this.status = CoffeeStatus.initial,
    this.coffees = const [],
    this.favorites = const [],
    this.downloads = const [],
    this.hasReachedMax = false,
    this.message,
  });

  final List<Coffee> coffees;
  final List<Coffee> favorites;
  final List<Coffee> downloads;
  final CoffeeStatus status;
  final bool hasReachedMax;
  final String? message;

  @override
  List<Object?> get props => [
    status,
    coffees,
    favorites,
    downloads,
    hasReachedMax,
    message,
  ];

  @override
  bool? get stringify => true;

  CoffeeState copyWith({
    List<Coffee>? coffees,
    List<Coffee>? favorites,
    List<Coffee>? downloads,

    CoffeeStatus? status,
    bool? hasReachedMax,
    String? message,
  }) => CoffeeState(
    status: status ?? this.status,
    coffees: coffees ?? this.coffees,
    favorites: favorites ?? this.favorites,
    downloads: downloads ?? this.downloads,
    hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    message: message ?? this.message,
  );
}

enum CoffeeStatus { initial, success, failure }
