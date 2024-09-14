import 'dart:async';
import 'package:balloon_crazy/components/balloon.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:balloon_crazy/config.dart'; // Import your config file

class BalloonCrazy extends FlameGame {
  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Define the number of rows and columns for the balloon grid
    const rows = 4;
    const columns = 15;

    // Define the size of each balloon
    final balloonSize = Vector2(
        balloonRadius * 2, balloonRadius * 2); // Use balloonRadius from config

    // Calculate the total width of the balloon grid
    final totalGridWidth = columns * (balloonSize.x + horizontalSpacing);

    // Calculate the X offset to center the grid horizontally
    final startX = (gameWidth - totalGridWidth) / 2;

    // Loop through rows and columns to add balloons to the game
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < columns; col++) {
        final balloon = Balloon(
          position: Vector2(
            startX +
                col *
                    (balloonSize.x +
                        horizontalSpacing), // X position centered horizontally
            topSpacing +
                row *
                    (balloonSize.y +
                        verticalSpacing), // Y position, adjusted by topSpacing
          ),
          size: balloonSize, // Size of the balloon based on balloonRadius
          velocity: Vector2(0, 0), // Stationary at first
        );
        add(balloon);
      }
    }
  }
}
