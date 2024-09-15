import 'dart:async';
import 'package:balloon_crazy/components/balloon.dart';
import 'package:balloon_crazy/components/game_title.dart';
import 'package:balloon_crazy/components/play_area.dart';
import 'package:balloon_crazy/config.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

enum PlayState { welcome, playing, gameOver, won }

class BalloonCrazy extends FlameGame
    with HasCollisionDetection, KeyboardEvents, TapDetector {
  BalloonCrazy()
      : super(
          camera: CameraComponent.withFixedResolution(
            width: gameWidth,
            height: gameHeight,
          ),
        );

  double get width => size.x;
  double get height => size.y;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    const rows = 4;
    const columns = 10;

    final balloonSize = Vector2(55, 55);
    const spacingX = 20.0;
    const spacingY = 20.0;

    camera.viewfinder.anchor = Anchor.topLeft;

    // Define the play area
    final playArea = PlayArea();
    world.add(playArea);

    // Position the game title
    final gameTitle = GameTitle();
    gameTitle.position = Vector2(10, 45);
    world.add(gameTitle);

    final totalGridWidth = columns * (balloonSize.x + spacingX) - spacingX;

    final startX = ((gameWidth - totalGridWidth) / 2) + 20;

    final startY = gameTitle.position.y + gameTitle.height + 250;

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < columns; col++) {
        final balloon = Balloon(
          position: Vector2(
            startX + col * (balloonSize.x + spacingX),
            startY + row * (balloonSize.y + spacingY),
          ),
          size: balloonSize,
          velocity: Vector2(0, 0),
        );
        world.add(balloon);
      }
    }

    debugMode = false;
  }
}
