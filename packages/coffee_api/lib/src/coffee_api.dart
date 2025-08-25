import 'package:coffee_api/coffee_api.dart';

/// Simple interface for a Coffee API.
abstract class CoffeeApi {
  CoffeeApi();

  Stream<Coffee> getCoffee({required int startIndex, required int quantity});
}
