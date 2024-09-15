import 'dart:async';
import 'package:balloon_crazy/components/balloon.dart';
import 'package:balloon_crazy/components/game_title.dart';
import 'package:balloon_crazy/config.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

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

  @override
  Color backgroundColor() => const Color(0xFF5555FA);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    const rows = 4;
    const columns = 10;

    final balloonSize = Vector2(30, 30); // Balloon size
    const spacingX = 5.0; // Horizontal spacing
    const spacingY = 5.0; // Vertical spacing

    final gameTitle = GameTitle();
    add(gameTitle);

    final totalGridWidth = columns * (balloonSize.x + spacingX) - spacingX;

    final startX = (gameWidth - totalGridWidth) / 2;

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < columns; col++) {
        final balloon = Balloon(
          position: Vector2(
            startX + col * (balloonSize.x + spacingX),
            100 + row * (balloonSize.y + spacingY),
          ),
          size: balloonSize,
          velocity: Vector2(0, 0),
        );
        add(balloon);
      }
    }
    debugMode = false;
  }
}
