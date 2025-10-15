import 'package:flame/components.dart';
import 'package:flutter/services.dart';

import 'package:balloon_crazy/config.dart';

class Player extends RectangleComponent with KeyboardHandler {
  Player({required super.position, required super.size})
    : super(anchor: Anchor.center);

  int horizontalDirection = 0;
  final moveSpeed = 300.0;

  @override
  void update(double dt) {
    super.update(dt);
    position.x += horizontalDirection * moveSpeed * dt;
    position.x = position.x.clamp(0, gameWidth);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalDirection = 0;
    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      horizontalDirection--;
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      horizontalDirection++;
    }
    return true;
  }
}
