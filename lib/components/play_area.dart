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
    size = Vector2(gameWidth * 0.8,
        gameHeight * 0.8); // Make PlayArea 80% of the game size
    position =
        Vector2(gameWidth * 0.1, gameHeight * 0.1); // Center it with margins
  }
}
