import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'package:balloon_crazy/balloon_crazy.dart';

void main() {
  final game = BalloonCrazy();
  runApp(GameWidget(
    game: game,
  ));
}
