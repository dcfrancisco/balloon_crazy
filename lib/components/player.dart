import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:balloon_crazy/balloon_crazy.dart';
import 'package:balloon_crazy/components/components.dart';
import 'package:balloon_crazy/config.dart';

class Player extends SpriteComponent
    with HasGameReference<BalloonCrazy>, CollisionCallbacks {
  Player({required super.position, required super.size})
    : super(anchor: Anchor.center);

  double targetX = 0;
  final moveSpeed = playerMoveSpeed;
  int heldBalloons = 0;
  late double initialY;
  List<SpriteComponent> heldBalloonSprites = [];
  bool _isBanking = false;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    sprite = await game.loadSprite('player.png');
    add(RectangleHitbox());
    initialY = position.y;
    targetX = position.x;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.playState == PlayState.playing) {
      final dx = targetX - position.x;
      if (dx.abs() > 1) {
        position.x += dx.sign * moveSpeed * dt;
        position.x = position.x.clamp(size.x / 2, gameWidth - size.x / 2);
      }
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Balloon && other.velocity.y > 0) {
      catchBalloon(other);
    }
  }

  void catchBalloon(Balloon balloon) {
    balloon.removeFromParent();
    heldBalloons++;
    game.score.value += 10;

    // Notify game that balloon was caught
    game.onBalloonCaught(balloon);

    // Increase SP (difficulty) in game
    game.increaseSP(0.5);

    // Add visual balloon above player
    _addVisualBalloon();
    // Check for automatic banking threshold. Use BP from game.
    final bp = game.bankPenalty;
    final threshold = (7 - bp);
    if (heldBalloons >= threshold) {
      bank();
    }
  }

  void _addVisualBalloon() async {
    final balloonSprite = SpriteComponent(
      sprite: await game.loadSprite('red_balloon.png'),
      size: Vector2(visualBalloonSize, visualBalloonSize),
      position: Vector2(0, -visualBalloonYOffset * heldBalloons),
      anchor: Anchor.center,
    );
    add(balloonSprite);
    heldBalloonSprites.add(balloonSprite);
  }

  void reset() {
    position.y = initialY;
    position.x = gameWidth / 2;
    targetX = gameWidth / 2;
    heldBalloons = 0;
    _isBanking = false;

    // Remove visual balloons
    for (var sprite in heldBalloonSprites) {
      sprite.removeFromParent();
    }
    heldBalloonSprites.clear();
  }

  /// Banks currently held balloons: plays per-balloon pop animation, awards
  /// 10 points per balloon, and resets heldBalloons and player's speed state.
  /// Safe against re-entrancy.
  Future<void> bank() async {
    if (_isBanking || heldBalloons == 0) return;
    _isBanking = true;
    final toBank = heldBalloons;
    const perBalloonMs = 100; // 0.1s per balloon

    // If this component isn't mounted (unit tests or isolated usage), the
    // TimerComponent won't tick. Fall back to a simple delayed loop so tests
    // remain deterministic and don't hang.
    if (!isMounted) {
      for (int i = 0; i < toBank; i++) {
        game.score.value += 10;
        if (heldBalloonSprites.isNotEmpty) {
          final last = heldBalloonSprites.removeLast();
          last.removeFromParent();
        }
        await Future.delayed(Duration(milliseconds: perBalloonMs));
      }
    } else {
      final completer = Completer<void>();
      var processed = 0;

      final timer = TimerComponent(
        period: perBalloonMs / 1000.0,
        repeat: true,
        onTick: () {
          // Award points per balloon
          game.score.value += 10;

          // Remove visual balloon if present
          if (heldBalloonSprites.isNotEmpty) {
            final last = heldBalloonSprites.removeLast();
            last.removeFromParent();
          }

          processed++;
          if (processed >= toBank) {
            completer.complete();
          }
        },
      );

      // Add the timer to this component so it ticks with the game loop
      add(timer);
      timer.timer.start();

      // Wait until timer processed all balloons
      await completer.future;

      // clean up
      timer.removeFromParent();
    }

    heldBalloons = 0;
    _isBanking = false;

    game.resetSPtoBase();
  }
}
