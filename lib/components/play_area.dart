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

    size = Vector2(gameWidth, gameHeight);
  }
}
