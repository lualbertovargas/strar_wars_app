import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nuevo_proyecto/colors/colors.dart';

import 'package:nuevo_proyecto/packages/characters_star_wars/controllers/controllers.dart';

// Capa de Presentación
class StarWarsHomePage extends StatefulWidget {
  final StarWarsController controller;

  const StarWarsHomePage({Key? key, required this.controller})
      : super(key: key);

  @override
  _StarWarsHomePageState createState() => _StarWarsHomePageState();
}

class _StarWarsHomePageState extends State<StarWarsHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _animation = Tween(begin: 0.0, end: 2 * pi).animate(_controller);

    widget.controller.initState(
      controller: _controller,
      animation: _animation,
      setState: setState,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackPrimary,
      body: GestureDetector(
        onVerticalDragUpdate: widget.controller.handleVerticalDragUpdate,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: 200,
                height: 180,
                color: Colors.black,
                child: Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateX(widget.controller.rotationAngleX)
                    ..rotateY(widget.controller.rotationAngleY)
                    ..rotateZ(widget.controller.rotationAngleZ)
                    ..rotateZ(widget.controller.animationValue * pi * 2),
                  alignment: Alignment.center,
                  child: Center(
                    child: Image.asset(
                      'assets/logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                backgroundColor: blackPrimary,
                color: yellowPrimary,
                onRefresh: widget.controller.fetchCharacters,
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Spacer(),
                        const Text(
                          'Filters:',
                          style: TextStyle(
                            color: yellowPrimary,
                            fontSize: 20,
                          ),
                        ),
                        const Spacer(),
                        DropdownButton<String>(
                          value: widget.controller.selectedGender,
                          dropdownColor: Colors.black,
                          onChanged: widget.controller.filterCharacters,
                          items: ['all', 'male', 'female', 'n/a']
                              .map<DropdownMenuItem<String>>((value) =>
                                  DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value.toUpperCase(),
                                      style:
                                          const TextStyle(color: yellowPrimary),
                                    ),
                                  ))
                              .toList(),
                        ),
                        const Spacer(),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount:
                            widget.controller.filteredCharacters.length + 1,
                        itemBuilder: (context, index) {
                          return widget.controller
                              .buildListItem(context, index);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
