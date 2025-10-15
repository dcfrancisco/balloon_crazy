import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:balloon_crazy/balloon_crazy.dart';
import 'package:balloon_crazy/components/components.dart';

class Balloon extends SpriteComponent
    with CollisionCallbacks, HasGameReference<BalloonCrazy> {
  late Vector2 _velocity;
  final int rowIndex;
  final int columnIndex;

  Balloon({
    required Vector2 position,
    required Vector2 size,
    required Vector2 velocity,
    required this.rowIndex,
    required this.columnIndex,
  }) : super(position: position, size: size, anchor: Anchor.center) {
    _velocity = velocity;
  }

  Vector2 get velocity => _velocity;

  set velocity(Vector2 newVelocity) {
    _velocity = newVelocity;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await Sprite.load('red_balloon.png');
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += _velocity * dt;
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Floor && _velocity.y > 0) {
      _showPopAnimation();
      removeFromParent();
      game.onLoseLife();
    }
  }

  void _showPopAnimation() {
    final pop = Pop(position: position.clone(), size: size * 1.2);
    parent?.add(pop);
  }
}
