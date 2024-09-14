import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:balloon_crazy/balloon_crazy.dart';
import 'package:balloon_crazy/config.dart';

class PlayArea extends RectangleComponent with HasGameReference<BalloonCrazy> {
  PlayArea()
      : super(
          paint: Paint()..color = const Color(0xFF5555FA),
          children: [RectangleHitbox()],
        );

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    // Use the size property directly from the game (FlameGame)
    size = Vector2(
        gameWidth, gameHeight); // gameRef.size gives you the current game size

    // Set the position (optional) if you want to adjust where the play area starts
    position = Vector2(0, 0); // Top-left corner
  }
}
