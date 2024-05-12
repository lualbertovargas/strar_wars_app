import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nuevo_proyecto/packages/characters_star_wars/controllers/controllers.dart';
import 'package:nuevo_proyecto/packages/characters_star_wars/models/character.model.dart';

void main() {
  group('StarWarsController', () {
    late StarWarsController controller;

    setUp(() {
      controller = StarWarsController();
    });

    test('Fetch characters', () async {
      await controller.fetchCharacters();

      // Esperar un tiempo prudencial antes de verificar los personajes
      await Future.delayed(const Duration(seconds: 5));

      // Verificar que la lista de personajes no está vacía
      expect(controller.characters.isNotEmpty, true);
    });
  });
}
