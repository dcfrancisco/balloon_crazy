import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';

class Floor extends PositionComponent with CollisionCallbacks {
  late Paint paint;

  /// Controls whether the floor should be drawn. Toggle from the game to
  /// hide/show the floor (used for welcome screen vs playing state).
  bool visible = true;

  Floor({required Vector2 position, required Vector2 size})
    : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(RectangleHitbox());
    paint = Paint()..color = Colors.brown;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (!visible) return;
    canvas.drawRect(size.toRect(), paint);
  }
}
