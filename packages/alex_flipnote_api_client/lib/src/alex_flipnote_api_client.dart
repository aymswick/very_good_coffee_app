import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

final Logger logger = Logger();

/// A Simple Client for Alex Flipnote's Coffee API.
/// It's a tiny python script running under a Hypercorn web server.
/// https://hypercorn.readthedocs.io/en/latest/index.html
class AlexFlipnoteApiClient {
  final apiBaseUrl = 'coffee.alexflipnote.dev';
  final http.Client networkClient;

  AlexFlipnoteApiClient({required this.networkClient});

  /// Get a random coffee in JSON format
  Future<Map<String, dynamic>> getCoffee(int startIndex) async {
    final response = await networkClient.read(
      Uri(host: apiBaseUrl, path: '/random.json', scheme: 'https'),
    );

    logger.d(response);

    final parsed = await jsonDecode(response);
    final filename = parsed['file'];

    return <String, dynamic>{
      'url': Uri.parse(filename),
      'name': filename.split('/').last,
    };
  }
}
