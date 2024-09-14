// Balloon Component (uses an image or sprite)
import 'package:flame/components.dart';

class Balloon extends SpriteComponent {
  final Vector2 velocity;

  Balloon({
    required Vector2 position,
    required Vector2 size,
    required this.velocity,
  }) : super(
          position: position,
          size: size,
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await Sprite.load('red_balloon.png'); // Load the balloon image
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt; // Update position based on velocity
  }
}
