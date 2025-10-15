import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:balloon_crazy/balloon_crazy.dart';

class Pop extends SpriteComponent with HasGameReference<BalloonCrazy> {
  Pop({required Vector2 position, required Vector2 size})
    : super(position: position, size: size, anchor: Anchor.center);
  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Load the balloon_pop.png sprite sheet (3x2 grid)
    final image = await game.images.load('balloon_pop.png');
    final spriteSheet = SpriteSheet(
      image: image,
      srcSize: Vector2(image.width / 3, image.height / 2), // 3 columns, 2 rows
    );

    // Get the red balloon from row 1 (second row), column 0
    sprite = spriteSheet.getSprite(1, 0);

    // Remove the pop animation after a short duration
    add(
      TimerComponent(
        period: 0.3,
        removeOnFinish: true,
        onTick: () => removeFromParent(),
      ),
    );
  }
}
