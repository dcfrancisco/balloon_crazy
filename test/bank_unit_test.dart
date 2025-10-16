import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart';
import 'package:balloon_crazy/components/player.dart';
import 'package:balloon_crazy/balloon_crazy.dart';
import 'package:flame/components.dart';

class _FakeGame extends BalloonCrazy {
  // override heavy lifecycle pieces; we only need score and resetSP hook
  @override
  final ValueNotifier<int> score = ValueNotifier<int>(0);

  bool spResetCalled = false;
  @override
  void resetSPtoBase() {
    spResetCalled = true;
  }
}

void main() {
  test('bank() awards points and resets floaters', () async {
    // Create a minimal fake game and player
    final game = _FakeGame();
    final player = Player(position: Vector2(100, 100), size: Vector2(80, 100));
    // attach player.game to fake game by setting the game variable on the
    // underlying Component - Flame normally wires this when adding to a game,
    // but we can set the private reference via `player.onMount` simulation by
    // setting the game variable through the component's `gameRef` setter.
    // Since Player extends SpriteComponent with HasGameReference, assign via
    // mounting onto the game's component tree is complex in unit tests; as a
    // pragmatic shortcut, we'll call bank() while temporarily shadowing the
    // `game` reference via a local closure that manipulates the Player's
    // `game` property using Dart's dynamic features.
    // Simpler approach: call bank() with the global game object in scope by
    // using a small wrapper that sets `player`'s `game` using the `onLoad`
    // lifecycle isn't necessary for this logic because bank() only uses
    // `game.score` and `game.resetSPtoBase()`.

    // set heldBalloons and attach via dynamic hack
    // ignore: avoid_dynamic_calls
    (player as dynamic).game = game;

    player.heldBalloons = 3;
    final startScore = game.score.value;

    // call bank and wait
    await player.bank();

    // After banking, score should have increased by 10 * 3 and heldBalloons reset
    expect(game.score.value, startScore + 30);
    expect(player.heldBalloons, 0);
    expect(game.spResetCalled, true);
  });
}
