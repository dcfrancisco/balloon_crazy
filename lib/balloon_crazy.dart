import 'dart:async';
import 'package:balloon_crazy/components/balloon.dart';
import 'package:balloon_crazy/config.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart'; // Import for color

class BalloonCrazy extends FlameGame {
  // Override backgroundColor to set the game background color
  @override
  Color backgroundColor() =>
      const Color(0xFF5555FA); // Set the background color

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Define the number of rows and columns for the balloon grid
    const rows = 4;
    const columns = 10;

    // Define the size of each balloon and the spacing between them
    final balloonSize = Vector2(30, 30); // Balloon size
    const spacingX = 5.0; // Horizontal spacing
    const spacingY = 5.0; // Vertical spacing

    // Calculate the total width of the balloon grid
    final totalGridWidth = columns * (balloonSize.x + spacingX);

    // Calculate the X offset to center the grid horizontally
    final startX = 35.0; //(gameWidth - totalGridWidth) / 2;

    // Loop through rows and columns to add balloons to the game
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < columns; col++) {
        final balloon = Balloon(
          position: Vector2(
            startX + col * (balloonSize.x + spacingX), // X position
            50 +
                row * (balloonSize.y + spacingY), // Y position with top spacing
          ),
          size: balloonSize, // Size of the balloon
          velocity: Vector2(0, 0), // Stationary at first, will drop randomly
        );
        add(balloon);
      }
    }
    debugMode = false;
  }
}
