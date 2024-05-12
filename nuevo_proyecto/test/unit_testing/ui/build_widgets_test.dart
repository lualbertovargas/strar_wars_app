import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nuevo_proyecto/packages/characters_star_wars/controllers/controllers.dart';
import 'package:nuevo_proyecto/packages/characters_star_wars/ui/pages/pages.dart';

void main() {
  group('StarWarsHomePage', () {
    late StarWarsController controller;

    setUp(() {
      controller = StarWarsController();
    });

    testWidgets('Widget construction', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: StarWarsHomePage(controller: controller),
      ));

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(GestureDetector), findsNWidgets(2)); // Cambio aquí
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Padding), findsNWidgets(2));
      expect(find.byType(Container), findsNWidgets(2));
      expect(find.byType(Transform), findsOneWidget);
      expect(find.byType(RefreshIndicator), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('Vertical drag gesture', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: StarWarsHomePage(controller: controller),
      ));

      // Aquí buscamos específicamente los GestureDetectors dentro de la columna
      final gestureDetectors = find.descendant(
        of: find.byType(Column),
        matching: find.byType(GestureDetector),
      );

      expect(gestureDetectors, findsNWidgets(2)); // Cambio aquí

      // Simulamos el gesto en el primer GestureDetector
      await tester.drag(gestureDetectors.first, const Offset(0.0, 200.0));

      // Verificamos que se haya llamado al método fetchMoreCharacters
      expect(controller.fetchMoreCharactersCalled, true);
    });

    // Otras pruebas aquí, como verificar la construcción de la lista de personajes, etc.
  });
}
