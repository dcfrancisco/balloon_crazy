import 'dart:async';

import 'package:balloon_crazy/balloon_crazy.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class PlayArea extends RectangleComponent with HasGameReference<BalloonCrazy> {
  PlayArea()
      : super(
          paint: Paint()..color = const Color(0xFF5555FA),
          children: [RectangleHitbox()],
        );

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    size = Vector2(game.width, game.height);
  }
}
