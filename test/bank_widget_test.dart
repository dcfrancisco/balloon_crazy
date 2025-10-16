import 'package:flutter_test/flutter_test.dart';
import 'package:balloon_crazy/balloon_crazy.dart';
import 'package:balloon_crazy/components/player.dart';
import 'package:flame/components.dart';

void main() {
  test('banking (unit style) clears visuals and awards score', () async {
    final game = BalloonCrazy();
    final player = Player(position: Vector2(100, 100), size: Vector2(80, 100));

    // attach game reference using dynamic (test-only shortcut)
    // ignore: avoid_dynamic_calls
    (player as dynamic).game = game;

    player.heldBalloons = 4;
    final startScore = game.score.value;

    await player.bank();

    expect(player.heldBalloons, 0);
    expect(game.score.value, startScore + (10 * 4));
  });
}
