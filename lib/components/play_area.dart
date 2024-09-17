import 'dart:async';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:balloon_crazy/balloon_crazy.dart';

class PlayArea extends RectangleComponent with HasGameReference<BalloonCrazy> {
  PlayArea()
      : super(
          paint: Paint()..color = const Color(0xFF5757F7),
        );

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    size = Vector2(game.width, game.height);
  }
}
