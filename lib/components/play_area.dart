import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:balloon_crazy/config.dart';
import 'package:balloon_crazy/balloon_crazy.dart';

class PlayArea extends RectangleComponent with HasGameReference<BalloonCrazy> {
  PlayArea()
      : super(
          paint: Paint()
            ..color = const Color(0xFF5555FA), // PlayArea background color
          children: [RectangleHitbox()],
          anchor: Anchor.center, // Anchor PlayArea to the center of the screen
        );

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    // Center the play area in the portrait layout
    size = Vector2(
        gameWidth * 0.9, gameHeight * 0.8); // Slightly smaller than full screen
    position = Vector2(gameWidth / 2, gameHeight / 2); // Centered in the screen
  }
}
