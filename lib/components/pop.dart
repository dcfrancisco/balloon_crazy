import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

class Pop extends SpriteAnimationComponent {
  Pop({
    required Vector2 position,
    required Vector2 size,
  }) : super(
          position: position,
          size: size,
          anchor: Anchor.center,
        );

  late final Images images;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    images = Images();
    final spriteSheet = await images.load('balloon_pop.png');
    final spriteSize = Vector2(32, 32); // Assuming each frame is 32x32 pixels
    final spriteSheetData = SpriteSheet(
      image: spriteSheet,
      srcSize: spriteSize,
    );

    animation = spriteSheetData.createAnimation(
      row: 0,
      stepTime: 0.1,
      to: 3,
    );
  }
}
