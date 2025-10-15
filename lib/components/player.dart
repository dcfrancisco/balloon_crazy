import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:balloon_crazy/balloon_crazy.dart';
import 'package:balloon_crazy/components/components.dart';
import 'package:balloon_crazy/config.dart';

enum PlayState { welcome, playing, gameOver, won }

class Player extends SpriteComponent
    with HasGameReference<BalloonCrazy>, CollisionCallbacks {
  Player({required super.position, required super.size})
    : super(anchor: Anchor.center);

  double targetX = 0;
  final moveSpeed = 500.0;
  int heldBalloons = 0;
  late double initialY;
  List<SpriteComponent> heldBalloonSprites = []; // Visual stack

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
    // Only move if the game is playing
    if (game.playState == PlayState.playing) {
      // Smoothly move towards target position
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
    position.y -= 13; // Rise 13 pixels (like original)
    game.score.value += 10;

    // Notify game that balloon was caught (for speed increase)
    game.onBalloonCaught(balloon);

    // Add visual balloon above player
    _addVisualBalloon();

    // Check if banking threshold reached (dynamic based on current row)
    final balloonsNeeded = game.getBalloonsNeededForBanking();
    if (heldBalloons >= balloonsNeeded) {
      bankBalloons();
    }
  }

  void _addVisualBalloon() async {
    final balloonSprite = SpriteComponent(
      sprite: await game.loadSprite('red_balloon.png'),
      size: Vector2(30, 30),
      position: Vector2(0, -13.0 * heldBalloons),
      anchor: Anchor.center,
    );
    add(balloonSprite);
    heldBalloonSprites.add(balloonSprite);
  }

  void bankBalloons() async {
    if (heldBalloons == 0) return;

    // Banking animation - pop each balloon
    for (int i = 0; i < heldBalloons; i++) {
      final pop = Pop(
        position: Vector2(position.x, position.y - (i * 13)),
        size: Vector2(30, 30),
      );
      parent?.add(pop);
      game.score.value += 10; // +10 points per balloon during banking

      // Remove visual balloon
      if (i < heldBalloonSprites.length) {
        heldBalloonSprites[i].removeFromParent();
      }

      // Small delay between pops
      await Future.delayed(const Duration(milliseconds: 100));
    }

    // Descend back to starting position (13 pixels per balloon)
    position.y = initialY;
    heldBalloons = 0;
    heldBalloonSprites.clear();

    // Reset speed on banking (key mechanic!)
    game.resetBalloonSpeed();
  }

  void popAllBalloons() {
    // Called when losing a life - pop all held balloons
    for (int i = 0; i < heldBalloonSprites.length; i++) {
      final pop = Pop(
        position: Vector2(position.x, position.y - (i * 13)),
        size: Vector2(30, 30),
      );
      parent?.add(pop);
      heldBalloonSprites[i].removeFromParent();
    }
    heldBalloons = 0;
    heldBalloonSprites.clear();
  }

  void reset() {
    position.y = initialY;
    position.x = gameWidth / 2;
    targetX = gameWidth / 2;
    heldBalloons = 0;
  }
}
