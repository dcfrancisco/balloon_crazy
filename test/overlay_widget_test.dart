import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:balloon_crazy/balloon_crazy.dart';
import 'package:flame/game.dart';

void main() {
  testWidgets('welcome overlay shows and starts game on tap', (tester) async {
    final game = BalloonCrazy();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: GameWidget(game: game)),
      ),
    );

    await tester.pumpAndSettle();

    // The overlay text is provided by OverlayScreen in the GameApp; check that the welcome overlay is present
    expect(find.text('TAP TO PLAY'), findsOneWidget);

    await tester.tap(find.text('TAP TO PLAY'));
    await tester.pumpAndSettle();

    expect(game.playState, equals(PlayState.playing));
  });
}
