import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Balloon extends CircleComponent {
  Balloon({
    required this.velocity,
    required super.position,
    required double radius,
  }) : super(
            radius: radius,
            anchor: Anchor.center,
            paint: Paint()
              ..color = const Color(0xff1e6091)
              ..style = PaintingStyle.fill);

  final Vector2 velocity;

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;
  }
}
