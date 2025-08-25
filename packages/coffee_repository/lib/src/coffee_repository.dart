import 'package:alex_flipnote_coffee_api/alex_flipnote_coffee_api.dart';
import 'package:coffee_api/coffee_api.dart';

class CoffeeRepository {
  final AlexFlipnoteCoffeeApi coffeeApi;
  CoffeeRepository(this.coffeeApi);

  /// Fetch a [quantity] of coffee pics, enforce paging via [startIndex] despite current API simplicity
  Stream<Coffee> getCoffee({required int startIndex, required int quantity}) =>
      coffeeApi.getCoffee(startIndex: startIndex, quantity: quantity);
}
