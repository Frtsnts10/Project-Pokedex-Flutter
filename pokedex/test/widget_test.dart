import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(PokedexApp());

    // Verify that the app builds and finds the MaterialApp (which MyApp returns).
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
