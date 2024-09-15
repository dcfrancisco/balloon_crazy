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

    // Adjust rows and columns based on available space
    const rows = 4;
    const columns = 10; // Adjust the number of columns

    // Define the size of each balloon
    final balloonSize = Vector2(55, 55); // New balloon size
    const spacingX = 20.0; // Horizontal spacing
    const spacingY = 20.0; // Vertical spacing

    camera.viewfinder.anchor = Anchor.topLeft;

    // Define the play area
    final playArea = PlayArea();
    world.add(playArea);

    // Position the game title
    final gameTitle = GameTitle();
    gameTitle.position = Vector2(10, 45);
    world.add(gameTitle);

    // Calculate the total width of the grid of balloons
    final totalGridWidth = columns * (balloonSize.x + spacingX) - spacingX;

    // Calculate the starting x position to center the grid
    final startX = ((gameWidth - totalGridWidth) / 2) + 20;

    // Position the balloons 50 pixels below the title
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
