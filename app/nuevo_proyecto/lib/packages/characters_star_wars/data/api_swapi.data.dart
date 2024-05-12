import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:nuevo_proyecto/packages/characters_star_wars/models/models.dart';

class StarWarsRepository {
  final HttpClient _httpClient;

  StarWarsRepository(this._httpClient);

  Future<List<Character>> fetchCharacters(int page) async {
    final List<Character> characters = [];

    try {
      final request = await _httpClient
          .getUrl(Uri.parse('https://swapi.dev/api/people/?page=$page'));
      final response = await request.close();

      if (response.statusCode == HttpStatus.ok) {
        final responseBody = await response.transform(utf8.decoder).join();
        final Map<String, dynamic> data = jsonDecode(responseBody);
        final List<dynamic> results = data['results'];

        characters
            .addAll(results.map((json) => Character.fromJson(json)).toList());
      } else {
        throw Exception('Failed to load characters');
      }
    } catch (e) {
      print('Error: $e');
    }

    return characters;
  }
}
