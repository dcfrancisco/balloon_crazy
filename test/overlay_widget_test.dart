import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:balloon_crazy/balloon_crazy.dart';
import 'package:balloon_crazy/ui/welcome_leaderboard.dart';

class _FakeGame extends BalloonCrazy {
  bool started = false;

  @override
  void startGame() {
    started = true;
  }
}

void main() {
  testWidgets('welcome overlay shows and starts game on tap', (tester) async {
    final game = _FakeGame();
    await tester.pumpWidget(
      MaterialApp(home: WelcomeLeaderboard(game: game)),
    );

    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('TAP TO PLAY'), findsOneWidget);

    await tester.tap(find.text('TAP TO PLAY'));
    await tester.pump(const Duration(milliseconds: 500));

    expect(game.started, isTrue);
  });
}
