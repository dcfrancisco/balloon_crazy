import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:balloon_crazy/ui/won_prompt.dart';
import 'package:balloon_crazy/balloon_crazy.dart';

// A minimal fake BalloonCrazy exposing only the score and startGame
class _FakeGame extends BalloonCrazy {
  _FakeGame() : super();

  @override
  void startGame() {
    // no-op for test
  }
}

void main() {
  testWidgets('WonPrompt shows score and buttons', (tester) async {
    final game = _FakeGame();
    game.score.value = 123;

    await tester.pumpWidget(MaterialApp(home: WonPrompt(game: game)));

    expect(find.text('YOU WON!'), findsOneWidget);
    expect(find.text('Score: 123'), findsOneWidget);
    expect(find.text('Save Score / Play Again'), findsOneWidget);
    expect(find.text('Skip & Play Again'), findsOneWidget);
  });
}
