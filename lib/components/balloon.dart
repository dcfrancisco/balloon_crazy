import 'dart:async';
import 'dart:math';
import 'package:balloon_crazy/config.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

class Balloon extends SpriteComponent {
  final Vector2 velocity;
  bool isDropping = false;
  double speed = 4.0;
  bool popped = false;
  final Random rand = Random();
  late SpriteAnimation popAnimation; // Balloon pop animation
  late SpriteAnimationComponent
      popAnimationComponent; // Animation component for pop

  Balloon({
    required Vector2 position,
    required Vector2 size,
    required this.velocity,
  }) : super(
          position: position,
          size: size,
          anchor: Anchor.center, // Centered balloon
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Load the balloon image (normal state)
    sprite = await Sprite.load('red_balloon.png');

    // Load the balloon pop animation with 3 frames
    popAnimation = await SpriteAnimation.load(
      'balloon_pop.png',
      SpriteAnimationData.sequenced(
        amount: 3, // 3 frames for the pop animation
        stepTime: 0.1, // Time between each frame (adjust as needed)
        textureSize: Vector2(size.x, size.y), // Size of each frame
      ),
    );

    // Create the pop animation component
    popAnimationComponent = SpriteAnimationComponent(
      animation: popAnimation,
      size: size,
      position: position,
      anchor: Anchor.center,
      removeOnFinish: true, // Remove the component once the animation finishes
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Balloon dropping logic
    if (isDropping && !popped) {
      position.y += speed * dt;
    }

    // Randomly trigger the balloon to drop
    if (!isDropping && rand.nextDouble() < 0.01) {
      isDropping = true;
    }

    // Check if balloon hits the floor
    if (position.y > gameHeight && !popped) {
      handlePop();
    }
  }

  // Handle the balloon pop
  void handlePop() {
    popped = true;
    remove(sprite as Component); // Remove the static sprite

    // Add the pop animation component
    add(popAnimationComponent);

    // Reset the balloon after the animation finishes
    Future.delayed(const Duration(milliseconds: 300), () {
      resetBalloon();
    });
  }

  // Reset the balloon after popping
  void resetBalloon() {
    popped = false;
    isDropping = false;
    position.y = 0; // Reset to the top
    sprite = Sprite.load('red_balloon.png') as Sprite?; // Reset balloon sprite
    speed += 0.5; // Increase speed for the next drop
  }
}
