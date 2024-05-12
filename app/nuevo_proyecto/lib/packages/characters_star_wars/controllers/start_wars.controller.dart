import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nuevo_proyecto/colors/colors.dart';
import 'package:nuevo_proyecto/packages/characters_star_wars/models/models.dart';
import 'package:nuevo_proyecto/packages/characters_star_wars/data/data.dart';

// Capa de Controlador
class StarWarsController {
  late AnimationController _controller;
  late Animation<double> _animation;
  List<Character> characters = [];
  List<Character> filteredCharacters = [];
  String selectedGender = 'all';
  int _currentCharacterCount = 0;
  final int _charactersPerPage = 15;
  bool _isLoading = false;
  double rotationAngleX = 0.0;
  double rotationAngleY = 0.0;
  double rotationAngleZ = 0.0;
  double animationValue = 0.0;
  bool fetchMoreCharactersCalled = false;
  late StreamSubscription<List<double>> _gyroscopeSubscription;
  late StarWarsRepository _repository;

  void initState({
    required AnimationController controller,
    required Animation<double> animation,
    required Function(void Function()) setState,
  }) {
    _controller = controller;
    _animation = animation;

    _gyroscopeSubscription =
        Gyroscope().gyroscopeStream.listen((List<double> event) {
      setState(() {
        rotationAngleX = event[0];
        rotationAngleY = event[1];
        rotationAngleZ = event[2];
      });
    });

    _repository = StarWarsRepository(HttpClient());
    fetchCharacters();
  }

  void dispose() {
    _controller.dispose();
    _gyroscopeSubscription.cancel();
  }

  void _rotateLogo() {
    _controller.forward(from: 0.0);
  }

  Future<void> fetchCharacters() async {
    _isLoading = true;

    try {
      characters = await _repository.fetchCharacters(1);
      _currentCharacterCount = characters.length;
      filteredCharacters = [...characters];
    } catch (e) {
      print('Error: $e');
    } finally {
      _isLoading = false;
    }
  }

  Future<void> fetchMoreCharacters() async {
    _isLoading = true;
    fetchMoreCharactersCalled = true;

    try {
      final charactersToAdd = await _repository.fetchCharacters(
          (_currentCharacterCount / _charactersPerPage).ceil() + 1);
      characters.addAll(charactersToAdd);
      _currentCharacterCount = characters.length;
      filterCharacters(selectedGender);
      _isLoading = false;
      _rotateLogo();
    } catch (e) {
      print('Error: $e');
      _isLoading = false;
    }
  }

  void filterCharacters(String? value) {
    selectedGender = value ?? 'all';
    if (selectedGender == 'all') {
      filteredCharacters = [...characters];
    } else {
      filteredCharacters = characters
          .where((character) => character.gender == selectedGender)
          .toList();
    }
  }

  Widget buildListItem(BuildContext context, int index) {
    if (index == filteredCharacters.length) {
      return _buildLoadMoreIndicator();
    } else {
      final character = filteredCharacters[index];
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white, width: 2),
            gradient: const RadialGradient(
              colors: [
                Colors.white,
                redSecundary,
                redTercery,
                redCuaternary,
                Colors.black,
              ],
              radius: 1.0,
              center: Alignment.bottomLeft,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 90.0,
              top: 10,
              bottom: 10,
            ),
            child: ListTile(
              title: Wrap(
                children: [
                  const Text(
                    'Nombre:',
                    style: TextStyle(
                      color: yellowPrimary,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    character.name,
                    style: const TextStyle(
                      color: yellowPrimary,
                    ),
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    children: [
                      const Text(
                        'Género:',
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(
                        width: 21,
                      ),
                      Text(
                        'Género: ${character.gender}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  Wrap(
                    children: [
                      const Text(
                        'Películas:',
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        character.movies.join(', '),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget _buildLoadMoreIndicator() {
    return _isLoading
        ? const Padding(
            padding: EdgeInsets.all(30.0),
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 10.0,
                backgroundColor: Colors.white,
                color: yellowPrimary,
              ),
            ),
          )
        : GestureDetector(
            onVerticalDragUpdate: (details) {
              if (details.primaryDelta! < -20) {
                fetchMoreCharacters();
              }
            },
            child: Container(
              height: 120,
              color: Colors.transparent,
              child: const Center(
                child: Text(
                  'Desliza hacia arriba para cargar más personajes',
                  style: TextStyle(
                    color: yellowPrimary,
                  ),
                ),
              ),
            ),
          );
  }

  void handleVerticalDragUpdate(DragUpdateDetails details) {
    if (details.primaryDelta! > 20) {
      fetchMoreCharacters();
    }
  }
}
