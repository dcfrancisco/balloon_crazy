import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flame/game.dart';

import 'package:balloon_crazy/balloon_crazy.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Create the game instance
    final game = BalloonCrazy();

    // Build our app and trigger a frame.
    await tester.pumpWidget(GameWidget(game: game));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    // Note: You need to add the actual tap action and verification here based on your game's implementation.
  });
}
