import 'dart:async';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:balloon_crazy/balloon_crazy.dart';

class PlayArea extends RectangleComponent with HasGameReference<BalloonCrazy> {
  PlayArea()
      : super(
          paint: Paint()..color = const Color.fromARGB(255, 87, 87, 247),
        );

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    size = Vector2(game.width, game.height);
  }
}
