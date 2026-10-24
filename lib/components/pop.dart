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

    // balloon_pop.png is a single-row, three-frame strip.
    final image = await game.images.load('balloon_pop.png');
    final spriteSheet = SpriteSheet(
      image: image,
      srcSize: Vector2(image.width.toDouble() / 3, image.height.toDouble()),
    );

    var frame = 0;
    sprite = spriteSheet.getSprite(0, frame);

    // Play each authored frame once, then remove the effect.
    add(
      TimerComponent(
        period: 0.1,
        repeat: true,
        onTick: () {
          frame++;
          if (frame >= 3) {
            removeFromParent();
            return;
          }
          sprite = spriteSheet.getSprite(0, frame);
        },
      ),
    );
  }
}
