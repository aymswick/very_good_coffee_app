import 'package:alex_flipnote_coffee_api/alex_flipnote_coffee_api.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:very_good_coffee/app/app.dart';
import 'package:very_good_coffee/bootstrap.dart';

void main() {
  // To support APIs with low rate limits, requests will be retried
  // on any HTTP error up to 3 times, mediated by a growing delay.
  // This is particularly useful for Alex's API which sends
  // HTTP 429 (Too Many Requests) errors when scrolling fast.
  final http.Client httpClient = RetryClient(
    http.Client(),
    when: (response) => response.statusCode != 200,
  );

  bootstrap(
    () => App(
      createCoffeeRepository: () => CoffeeRepository(
        AlexFlipnoteCoffeeApi(networkClient: httpClient),
      ),

      httpClient: httpClient,
    ),
  );
}
