import 'package:alex_flipnote_api_client/alex_flipnote_api_client.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:logger/logger.dart';

final Logger _logger = Logger();

class CoffeeRepository {
  final AlexFlipnoteApiClient apiClient;
  CoffeeRepository(this.apiClient);

  /// Fetch a [quantity] of coffee pics, enforce paging via [startIndex] despite current API simplicity
  Future<List<Coffee>> fetchCoffees({
    required int startIndex,
    required int quantity,
  }) async {
    try {
      final List<Coffee> coffees = [];

      for (int i = 0; i < quantity; i++) {
        final response = await apiClient.getCoffee(startIndex);

        coffees.add(Coffee(url: response['url'], name: response['name']));
      }

      return coffees;
    } catch (e) {
      throw Exception(e);
    }
  }
}
