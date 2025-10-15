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
  final moveSpeed = playerMoveSpeed;
  int heldBalloons = 0;
  late double initialY;
  List<SpriteComponent> heldBalloonSprites = [];

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

    // Add visual balloon above player
    _addVisualBalloon();
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

    // Remove visual balloons
    for (var sprite in heldBalloonSprites) {
      sprite.removeFromParent();
    }
    heldBalloonSprites.clear();
  }
}
