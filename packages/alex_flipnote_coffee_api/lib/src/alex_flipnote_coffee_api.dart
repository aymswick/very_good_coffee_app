import 'dart:async';
import 'dart:convert';

import 'package:coffee_api/coffee_api.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

final Logger logger = Logger();

/// A Simple Client for Alex Flipnote's Coffee API.
/// It's a tiny python script running under a Hypercorn web server.
/// https://hypercorn.readthedocs.io/en/latest/index.html
class AlexFlipnoteCoffeeApi extends CoffeeApi {
  final apiBaseUrl = 'coffee.alexflipnote.dev';

  final http.Client networkClient;

  AlexFlipnoteCoffeeApi({required this.networkClient});

  @override
  Stream<Coffee> getCoffee({
    required int startIndex,
    required int quantity,
  }) async* {
    for (int i = 0; i <= quantity; i++) {
      final response = await networkClient.read(
        Uri(host: apiBaseUrl, path: '/random.json', scheme: 'https'),
      );

      logger.d(response);

      final parsed = await jsonDecode(response);
      final filename = parsed['file'];

      yield Coffee(url: Uri.parse(filename), name: filename.split('/').last);
    }
  }
}
