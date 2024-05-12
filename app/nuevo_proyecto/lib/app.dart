import 'package:flutter/material.dart';
import 'package:nuevo_proyecto/packages/characters_star_wars/ui/pages/pages.dart';
import 'package:nuevo_proyecto/packages/characters_star_wars/controllers/controllers.dart';

class StarWarsApp extends StatelessWidget {
  const StarWarsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final StarWarsController controller = StarWarsController();
    return MaterialApp(
      title: 'Star Wars App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: StarWarsHomePage(controller: controller),
    );
  }
}
