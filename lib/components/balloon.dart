import 'package:flame/components.dart';
import 'package:balloon_crazy/balloon_crazy.dart';
import 'package:balloon_crazy/components/components.dart';

class Balloon extends SpriteComponent with HasGameReference<BalloonCrazy> {
  Vector2 velocity;
  final int domainId;
  final int rowIndex;
  final int columnIndex;
  bool _resolved = false;

  Balloon({
    required Vector2 position,
    required Vector2 size,
    required this.velocity,
    this.domainId = 0,
    required this.rowIndex,
    required this.columnIndex,
  }) : super(position: position, size: size, anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await Sprite.load('red_balloon.png');
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_resolved) return;
    final previousY = position.y;
    position += velocity * dt;
    if (!isMounted) return;

    if (game.balloonCrossedPlayer(
      this,
      previousY: previousY,
      nextY: position.y,
    )) {
      _resolved = true;
      game.player.catchBalloon(this);
      return;
    }
    if (game.balloonCrossedFloor(
      this,
      previousY: previousY,
      nextY: position.y,
    )) {
      _resolved = true;
      _showPopAnimation();
      removeFromParent();
      game.onBalloonMissed(this);
    }
  }

  void _showPopAnimation() {
    final pop = Pop(position: position.clone(), size: size * 1.2);
    parent?.add(pop);
  }
}
