import 'dart:async';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:balloon_crazy/balloon_crazy.dart';
import 'package:balloon_crazy/components/components.dart';
import 'package:balloon_crazy/config.dart';

class PlayArea extends RectangleComponent with HasGameReference<BalloonCrazy> {
  late Player player;
  late Floor floor;

  PlayArea() : super(paint: Paint()..color = const Color(0xFF5757F7));

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    size = Vector2(game.width, game.height);

    final floorPositionY = gameHeight - floorHeight;

    player = Player(
      position: Vector2(gameWidth / 2, floorPositionY - playerInitialYOffset),
      size: Vector2(playerWidth, playerHeight),
    );
    player.opacity = 0;

    floor = Floor(
      position: Vector2(0, floorPositionY),
      size: Vector2(gameWidth, floorHeight),
    );
  }

  void resetGame() {
    player.reset();
    player.opacity = 1; // Show player when game starts
  }
}
