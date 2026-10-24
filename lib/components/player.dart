import 'dart:async';
import 'dart:math' as math;
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
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
  late Sprite _readySprite;
  SpriteSheet? _fallSheet;
  bool _isMissAnimating = false;
  double _missElapsed = 0;
  double _missStartX = 0;
  double _missBaseY = 0;
  void Function()? _missFinished;

  bool get isMissAnimating => _isMissAnimating;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    _readySprite = await game.loadSprite('player.png');
    sprite = _readySprite;
    final fallImage = await game.images.load('player_fall_sheet.png');
    _fallSheet = SpriteSheet(
      image: fallImage,
      srcSize: Vector2(
        fallImage.width.toDouble() / 6,
        fallImage.height.toDouble(),
      ),
    );
    add(RectangleHitbox());
    initialY = position.y;
    targetX = position.x;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_isMissAnimating) {
      _updateMissAnimation(dt);
      return;
    }
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

    // Notify game that balloon was caught
    game.onBalloonCaught(balloon);

    // Add visual balloon above player
    _addVisualBalloon();
  }

  void clearHeldVisuals() {
    heldBalloons = 0;
    for (final sprite in heldBalloonSprites) {
      sprite.removeFromParent();
    }
    heldBalloonSprites.clear();
  }

  void _addVisualBalloon() async {
    final balloonSprite = SpriteComponent(
      sprite: await game.loadSprite('red_balloon.png'),
      size: Vector2(visualBalloonSize, visualBalloonSize),
      position: Vector2(0, -visualBalloonYOffset * heldBalloons),
      anchor: Anchor.center,
    );
    // A bank can settle while the asset is loading. Do not resurrect a
    // visual balloon after the domain has cleared the held stack.
    if (heldBalloons == 0 || !isMounted) return;
    add(balloonSprite);
    heldBalloonSprites.add(balloonSprite);
  }

  void reset() {
    _isMissAnimating = false;
    _missFinished = null;
    sprite = _readySprite;
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

  /// Plays the original BASIC miss movement: a short rightward zig-zag,
  /// followed by an upward exit. The game supplies the state transition after
  /// the animation completes.
  void playMissAnimation({required void Function() onComplete}) {
    final sheet = _fallSheet;
    if (_isMissAnimating || sheet == null) return;
    _isMissAnimating = true;
    _missElapsed = 0;
    _missStartX = position.x;
    _missBaseY = initialY;
    _missFinished = onComplete;
    sprite = sheet.getSprite(0, 0);
  }

  void _updateMissAnimation(double dt) {
    final sheet = _fallSheet;
    if (sheet == null) return;
    _missElapsed += dt;
    final frame = math.min(5, (_missElapsed / 0.12).floor());
    sprite = sheet.getSprite(0, frame);

    const zigZagDuration = 0.72;
    if (_missElapsed < zigZagDuration) {
      final progress = (_missElapsed / zigZagDuration).clamp(0.0, 1.0);
      position.x =
          _missStartX + (gameWidth - playerWidth / 2 - _missStartX) * progress;
      position.y = _missBaseY - math.sin(progress * math.pi * 3) * 18;
    } else {
      position.x = gameWidth - playerWidth / 2;
      position.y -= 260 * dt;
    }

    if (_missElapsed >= 1.15) {
      final callback = _missFinished;
      _isMissAnimating = false;
      _missFinished = null;
      sprite = _readySprite;
      position.y = _missBaseY;
      callback?.call();
    }
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
