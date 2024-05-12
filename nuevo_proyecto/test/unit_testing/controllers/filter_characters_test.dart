import 'package:flutter_test/flutter_test.dart';
import 'package:nuevo_proyecto/packages/characters_star_wars/controllers/controllers.dart';
import 'package:nuevo_proyecto/packages/characters_star_wars/models/character.model.dart';

void main() {
  group('StarWarsController', () {
    late StarWarsController controller;

    setUp(() {
      controller = StarWarsController();
    });

    test('Filter characters', () {
      final maleCharacter =
          Character(name: 'Luke Skywalker', gender: 'male', movies: []);
      final femaleCharacter =
          Character(name: 'Leia Organa', gender: 'female', movies: []);

      controller.characters = [maleCharacter, femaleCharacter];

      controller.filterCharacters('male');
      expect(controller.filteredCharacters.length, 1);
      expect(controller.filteredCharacters[0].gender, 'male');

      controller.filterCharacters('female');
      expect(controller.filteredCharacters.length, 1);
      expect(controller.filteredCharacters[0].gender, 'female');

      controller.filterCharacters('n/a');
      expect(controller.filteredCharacters.length, 0);

      controller.filterCharacters(null);
      expect(controller.filteredCharacters.length, 2);
    });
  });
}
